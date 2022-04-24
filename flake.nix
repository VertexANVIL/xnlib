{
    description = "XTended Nix Library";
    inputs.nixpkgs.url = "nixpkgs/nixos-21.11";

    outputs = inputs@{ self, ... }: let
        makeLibrary = import ./lib {
            inherit inputs;
        };
    in rec {
        lib = makeLibrary inputs.nixpkgs.lib;
        utils = { inherit makeLibrary; };
    };
}
