{
  description = "nini";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      systems = nixpkgs.lib.systems.flakeExposed;

      forAllSystems =
        f:
        lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );
    in
    {
      devShells = forAllSystems (
        {
          system,
          pkgs,
          ...
        }:
        {
          default = pkgs.mkShellNoCC {
            packages = [
              # Formatters
              pkgs.treefmt
              pkgs.nixfmt
              pkgs.prettier
              pkgs.taplo
              pkgs.fish
            ];
          };
        }
      );

      packages = forAllSystems (
        { pkgs, ... }:
        {
          default = pkgs.callPackage ./package.nix { };
        }
      );

      nixosModules.default = import ./module.nix self;

      formatter = forAllSystems ({ pkgs, ... }: pkgs.treefmt);
    };
}
