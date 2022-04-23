{ lib, ... }:
let
    inherit (builtins) readDir pathExists mapAttrs;
    inherit (lib) optionalAttrs filterAttrs removePrefix;
in rec {
    /**
    Synopsis: mkProfileAttrs _path_

    Recursively import the subdirs of _path_ containing a default.nix.

    Example:
    let profiles = mkProfileAttrs ./profiles; in
    assert profiles ? core.default; 0
    **/
    mkProfileAttrs = { dir, root ? dir, suffix ? "/default.nix" }: let
        imports = let
            files = readDir dir;
            p = n: v: v == "directory";
        in filterAttrs p files;

        f = n: _: let
            path = "${dir}/${n}";
            full = "${path}${suffix}";
        in optionalAttrs (pathExists full) {
            _name = removePrefix "${toString root}/" (toString path);
            defaults = [ full ];
        } // mkProfileAttrs {
            dir = path;
            inherit root suffix;
        };
    in mapAttrs f imports;
}
