# Your custom machine setup.
#
# This file is not in git and contains your setup and some secrets.

{ config, pkgs, lib, ... }:

{
  # Configure YOUR system in here. Check `system/SysConfig.nix` for a complete
  # list of options and their description.
  SysConfig = {

    ###########################################################################
    # System
    #

    # See: https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    #
    # For a new, fresh install: set to the current release and KEEP it there.
    stateVersion = "23.05"; # Did you read the comment?

    # The hostname
    hostName = "worky";

    # The platform this is running on
    hostPlatform = "x86_64-linux";

    ###########################################################################
    # Users
    #

    # Add these keys to the list of authorized keys for the created user and
    # root. This ensures that the listed users can log into that machine. A
    # default to my current workstation is set. Extend using lib.mkOptionDefault:
    authorizedKeys = lib.mkOptionDefault [
      # Add more ssh public keys:
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIz2weQ+ATNAbRmMazQrFOW2TdYQj4VlPr+3CuCNiMeb seb@worky"
    ];

    # The single main user:
    user = {
      realName = "Sebastian";

      # Login name
      name = "seb";

      # Use mkpasswd. (Considered a secret!)
      passHash = "abcdefghijklmnopqrstuvwxyz";

      # Additional user groups. Also check system/user.nix
      extraGroups = [ ];

      # Add ssh pub keys as authorized keys for this user. Will be merged with the 
      # global authorizedKeys value.
      authorizedKeys = [ ];
    };

    # Use mkpasswd. (Considered a secret!)
    root = { passHash = "abcdefghijklmnopqrstuvwxyz"; };

    ###########################################################################
    # Features
    #

    # Syncthing: The device ID of the syncthing server to use. If unset, syncthing
    # is disabled. (Considered a secret!)
    syncthing.serverId = "123123-adssfdsd-321123-asfghdfg-234234234-sdfsdfdsf";
  };

  # Add more packages:
  environment.systemPackages = with pkgs; [ ];

  # The list of other modules to import. This is the spot where you can be
  # more or less specific on which modules get loaded.
  imports = [
    # This is a workstation - to the common workstation setup is provided in here.
    ./workstation.nix

    # The module that defines the actual machine setup. This includes hardware
    # configs, disk setup, ... everything you need physically to have a machine
    # that boots and runs a linux kernel.
    ./machines/RazerBlade15_Advanced_Late2020.nix

    ###########################################################################
    # Custom modules
    #

    # ...
  ];
}
