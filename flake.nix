{
  description = "nini";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      self,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      flake.nixosModules.default = import ./module.nix self;

      perSystem =
        {
          pkgs,
          ...
        }:
        {
          packages.default = pkgs.callPackage ./package.nix { };
        };
    };
}
