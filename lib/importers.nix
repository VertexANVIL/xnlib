{ lib, ... }:
let
    inherit (builtins) filter readDir;
    inherit (lib) hasSuffix removeSuffix nameValuePair
        filterAttrs mapAttrs' genAttrs' mapFilterAttrs;
in rec {
    # Convert a list to file paths to attribute set
    # that has the filenames stripped of nix extension as keys
    # and imported content of the file as value.
    pathsToImportedAttrs = paths: let
        paths' = filter (hasSuffix ".nix") paths;
    in
        genAttrs' paths' (path: {
            name = removeSuffix ".nix" (baseNameOf path);
            value = import path;
        });
    
    recImportFiles = { dir, _import }:
        mapFilterAttrs (_: v: v != null) (n: v:
            if n != "default.nix" && hasSuffix ".nix" n && v == "regular" then
                let name = removeSuffix ".nix" n; in nameValuePair (name) (_import name)
            else nameValuePair ("") (null)
        ) (readDir dir);
    
    recImportDirs = { dir, _import }:
        mapFilterAttrs (_: v: v != null) (n: v:
            if v == "directory" then nameValuePair n (_import n)
            else nameValuePair ("") (null)
        ) (readDir dir);
    
    # converts nix files in directory to name/value pairs
    nixFilesIn = dir: mapAttrs' (name: value: nameValuePair (removeSuffix ".nix" name) (import (dir + "/${name}")))
        (filterAttrs (name: _: hasSuffix ".nix" name) (readDir dir));
}
