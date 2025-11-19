{ config, pkgs, ... }:

{
  imports = [
    # Override some security errors
    ./permittedInsecurePackages.nix
  ];
}
