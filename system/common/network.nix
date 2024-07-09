{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Network
  #

  # The system "name" aka hostname
  networking.hostName = config.SysConfig.hostName;

  # NOTE: a lot of options can be modified per interface. Use the interfaces
  # key: networking.interfaces.wlo1.PROPERTY

  networking = {
    # Enable DHCP by default on all network devices
    useDHCP = lib.mkDefault true;

    # Need to disable IPv6?
    # enableIPv6 = false;

    # Custom nameservers?
    # nameservers = [ "1.1.1.1" "1.0.0.1" ];

    # Some more default options for all interfaces
    # defaultGateway = "192.168.1.1";

    # Firewall setup
    firewall = {
      enable = lib.mkDefault true;
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
    };
  };
}
