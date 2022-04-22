{
    description = "XTended Nix Library";
    inputs.nixpkgs.url = "nixpkgs/nixos-21.11";

    outputs = inputs@{ self, ... }: {
        lib = import ./lib {
            inherit inputs;
        };
    };
}
