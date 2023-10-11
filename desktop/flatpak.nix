

{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Flatpak Support
  #

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Nice Software browser for flatpak
  environment.systemPackages = with pkgs; [ gnome.gnome-software ];

  # Do not forget: flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}
