{ lib, ... }:
let
    inherit (builtins) filter readDir unsafeDiscardStringContext;
    inherit (lib) hasSuffix removeSuffix nameValuePair pathExists
        optional flatten filterAttrs mapAttrs' genAttrs' mapFilterAttrs attrNames;
in rec {
    # Convert a list to file paths to attribute set
    # that has the filenames stripped of nix extension as keys
    # and imported content of the file as value.
    pathsToImportedAttrs = paths: let
        paths' = filter (hasSuffix ".nix") paths;
    in
        genAttrs' paths' (path: {
            name = removeSuffix ".nix" (baseNameOf (unsafeDiscardStringContext path));
            value = import path;
        });

    # Traverses a directory tree and returns all dirs with default.nix files
    # Returns a list of paths
    recursiveModuleTraverse = dir: let
        folders = attrNames (filterAttrs (n: v: v == "directory") (readDir dir));
        results = flatten (map (d: recursiveModuleTraverse (dir + "/${d}")) folders);
        default = dir + "/default.nix";
    in (optional (pathExists default) [default]) ++ results;

    # !!! NOT ACTUALLY RECURSIVE! Just imports all nix files in a dir
    recImportFiles = { dir, _import }:
        mapFilterAttrs (_: v: v != null) (n: v:
            if n != "default.nix" && hasSuffix ".nix" n && v == "regular" then
                let name = removeSuffix ".nix" n; in nameValuePair (name) (_import name)
            else nameValuePair ("") (null)
        ) (readDir dir);

    # !!! NOT ACTUALLY RECURSIVE! Just imports all dirs in a dir
    recImportDirs = { dir, _import, nameModifier ? null }:
        mapFilterAttrs (_: v: v != null) (n: v: let
            name = if nameModifier != null then nameModifier n else n;
        in
            if v == "directory" then nameValuePair name (_import n)
            else nameValuePair ("") (null)
        ) (readDir dir);

    # converts nix files in directory to name/value pairs
    nixFilesIn = dir: mapAttrs' (name: value: nameValuePair (removeSuffix ".nix" name) (import (dir + "/${name}")))
        (filterAttrs (name: _: hasSuffix ".nix" name) (readDir dir));
}
