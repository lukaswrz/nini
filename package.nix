{
  writers,
  nixos-rebuild,
  openssh,
  lib,
}:
writers.writeFishBin "nini" {
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      nixos-rebuild
      openssh
    ]}"
  ];
} (builtins.readFile ./nini)
