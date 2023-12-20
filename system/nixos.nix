{ config, lib, pkgs, ... }:

{
  #############################################################################
  # NixOS Base Setup
  #

  # Do not install the docs of packages and nix by default. This saves a lot
  # of memory.
  documentation.nixos.enable = false;
  documentation.doc.enable = false;
  documentation.info.enable = false;
  documentation.dev.enable = false;
  # ... Except man pages
  documentation.man.enable = true;

  # Install some nix tools.
  environment.systemPackages = with pkgs; [ nixos-option nix-index nixfmt ];

  #############################################################################
  # Nix Base Setup
  #

  # Generally allow unfree software
  nixpkgs.config.allowUnfree = true;
  # Hardware Platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  #############################################################################
  # Systemd & Journal  Setup
  #

  # Set the timeout of SystemD to 30s. Default is 90s.
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=30s
  '';

  # Journal keeps growing and growing. Limit.
  services.journald.extraConfig = "SystemMaxUse=100M";
  systemd.coredump = {
    # Needs to be enabled or the kernel throws the dumps into the process directory
    enable = true;
    # Tell systemd where to keep those: none - disabled, journal - store alongside the journal, external - store in /var/lib/systemd/coredump.
    # Journal is usually a good choice. The Journal rotation rules apply so we do not store hundresd
    # MaxUse defines the max size of dump storage if "external"
    extraConfig = ''
      Storage=journal
      MaxUse=256M
    '';
  };

  #############################################################################
  # Nix Householding Setup
  #

  # Nix Package Manager optimization and garbage colection
  nix = {
    settings = {
      # Optimise syslinks
      auto-optimise-store = true;
    };

    # Automatic garbage collection ever week
    gc = {
      automatic = true;
      dates = "daily";
      # Delete all generations older than x,
      options = "--delete-older-than 7d";
    };
  };

  #############################################################################
  # Nix Features
  #

  nix.settings.experimental-features = [
    # To enable the nice experimental nix command features
    "nix-command"

    # Flakes support
    # "flakes"

  ];
}
