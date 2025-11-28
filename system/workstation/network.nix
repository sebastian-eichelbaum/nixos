{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Network
  #

  networking = {
    # Use Network Manager by default.
    networkmanager.enable = true;

    # Firewall setup
    firewall = {
      # Open specific ports in the firewall:
      allowedTCPPorts = [
        # Used by Gradio based AI web frontends. Open to allow access in the local network.
        7860

        # Used by vite
        5173
        5174
        5175
      ];
    };
  };

  # Manage Wifi networks using the nm applet
  programs.nm-applet.enable = true;

  # VPN Tools - only add common user-space tools here
  environment.systemPackages = with pkgs; [ wireguard-tools ];
}
