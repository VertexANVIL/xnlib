{ inputs, ... }:
let
    nixLib = inputs.nixlib.lib;
    inherit (nixLib) fix;
in fix (self: { inputs ? {}, extender ? {} }@all: let
    # construct internal lib
    lib = nixLib // (self all);

    f = path: import path ({
        inherit lib inputs;
    } // inputs);
in rec {
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

    # extends with a custom lib
    extend = attrs: self (all // {
        extender = extender // attrs;
    });

    extendByPath = path: extend (
        import path { inherit lib; }
    );

    # overrides with custom imports
    override = inputs: self (all // {
        inherit inputs;
    });

    inherit (attrs) mapFilterAttrs genAttrs' attrCount defaultAttrs defaultSetAttrs
        imapAttrsToList recursiveMerge recursiveMergeAttrsWithNames recursiveMergeAttrsWith;
    inherit (lists) filterListNonEmpty;
    inherit (importers) pathsToImportedAttrs recImportFiles recImportDirs nixFilesIn;
    inherit (misc) optionalPath optionalPathImport isIPv6 tryEval';

    inherit (objects.addrs) addrOpts addrToString addrToOpts addrsToOpts;
} // extender) {}
