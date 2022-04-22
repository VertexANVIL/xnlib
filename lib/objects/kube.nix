{ lib, pkgs ? null, ... }: let
    inherit (builtins) toJSON fromJSON readFile toFile;
    inherit (lib) splitString concatStringsSep last drop;

    friendlyPathName = path: let
        f = last (splitString "/" path);
    in concatStringsSep "-" (drop 1 (splitString "-" f));
in rec {
    compileKubeManifests = attrs: let
        source = pkgs.writeText "resources.json" (toJSON attrs);
        result = pkgs.runCommand "kube-compile" {}
            "${pkgs.yq-go}/bin/yq e -P '.[] | splitDoc' ${source} > $out";
    in readFile result;

    # Builds a Kustomization and returns Kubernetes objects
    buildKustomization = path: let
        result = pkgs.runCommand "kustomize-build-${friendlyPathName path}" {}
            "${pkgs.kustomize}/bin/kustomize build ${path} | ${pkgs.yq-go}/bin/yq ea -o=json '[.]' - > $out";
    in fromJSON (readFile result);
}
