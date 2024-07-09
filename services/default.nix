{ config, pkgs, lib, ... }:

{
  imports = [
    # Syncthing service config - provides sync for the shared folder and photos
    ./syncthing.nix
  ];
}
