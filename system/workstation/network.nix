{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Network
  #

  networking = {
    # Enable DHCP by default on all network devices
    useDHCP = lib.mkDefault true;
    # Modify per device:
    # interfaces.wlo1.useDHCP = lib.mkDefault true;

    # Use Network Manager by default.
    networkmanager.enable = true;
    # You could also use wap_supplicant
    # wireless.enable = true;

    # Need to disable IPv6?
    # enableIPv6 = false;

    # Custom nameservers?
    # nameservers = [ "1.1.1.1" "1.0.0.1" ];

    # Firewall setup
    firewall = {
      enable = true;
      # Open specific ports in the firewall:
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
    };

    # Some more default options for all interfaces
    # defaultGateway = "192.168.1.1";
  };

  # Wake on lan is of for all devices by default.
  # networking.interfaces.wlo1.wakeOnLan.enable = false;

  # Manage Wifi networks using the nm applet
  programs.nm-applet.enable = true;
}
