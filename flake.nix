{
    description = "XTended Nix Library";
    inputs.nixlib.url = "github:nix-community/nixpkgs.lib";

    outputs = inputs@{ self, ... }: {
        lib = import ./lib {
            inherit inputs;
        };
    };
}
