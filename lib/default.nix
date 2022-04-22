{ inputs, ... }:
let
    nixLib = inputs.nixpkgs.lib;
    inherit (nixLib) fix;
in fix (self: let
    f = path: import path ({
        lib = self;
        inherit inputs;
    } // inputs);
in nixLib // (rec {
    attrs = f ./attrs.nix;
    lists = f ./lists.nix;
    importers = f ./importers.nix;
    misc = f ./misc.nix;

    # custom stuff
    objects = {
        addrs = f ./objects/addrs.nix;
    };

    ansi = f ./ansi.nix;
    systemd = f ./systemd.nix;

    inherit (attrs) mapFilterAttrs genAttrs' attrCount defaultAttrs defaultSetAttrs
        imapAttrsToList recursiveMerge recursiveMergeAttrsWithNames recursiveMergeAttrsWith;
    inherit (lists) filterListNonEmpty;
    inherit (importers) pathsToImportedAttrs recImportFiles recImportDirs nixFilesIn;
    inherit (misc) optionalPath optionalPathImport isIPv6 tryEval';

    inherit (objects.addrs) addrOpts addrToString addrToOpts addrsToOpts;
}))
