{ config, pkgs, lib, ... }:

{
  imports = [
    # Dev base-line
    ./common.nix

    # Everything required for Unity Development
    ./unity.nix
  ];
}
