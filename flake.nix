{
  description = "Aider package";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
    let
      # pkgs = import nixpkgs { system = "x86_64-linux"; };
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      aider = pkgs.callPackage ./aider-package.nix {};
    in {
      # defaultPackage.x86_64-linux = pkgs.callPackage ./aider-package.nix {};

      packages = {
        default = aider;
      };

      defaultPackage.${system} = aider;
    };
}
