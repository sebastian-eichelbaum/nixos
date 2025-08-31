{ config, pkgs, ... }:

{
  imports = [
    # Fixes anydesk download issues that occur from time to time.
    ./anydesk.nix

    # Override some security errors
    ./permittedInsecurePackages.nix
  ];
}
