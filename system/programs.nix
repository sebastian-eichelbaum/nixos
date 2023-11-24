{ config, lib, pkgs, ... }:

{
  # ATTENTION: this defines some basic system packages that are assumed to be
  # useful for all users, especially while administrating NixOS.

  # DO NOT: no user specific packages. This is the base-line system.

  #############################################################################
  # System packages
  #

  # Use NeoVim as the default editor. No editor, no NixOs config changes ;-)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # Alias vi and vim to neovim
    vimAlias = true;
    viAlias = true;

    # All the nice COC/LSP Plugins need this
    withNodeJs = true;

    # Unwrapped version
    package = pkgs.neovim-unwrapped;
  };

  # Also tell everyone else that nvim is THE editor
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Install some sane default programs for system management.
  environment.systemPackages = with pkgs;
    [
      #############################
      # Standard tools
      #

      killall
      psmisc # fuser, (also killall), pstree, ...
      wget
      htop
      file
      rsync

      #############################
      # Administrative tools
      #

      # Partitioning and file system stuff
      parted
      exfatprogs
      ntfs3g

      # Some hardware tools/monitors
      pciutils
      usbutils
      smartmontools
      lm_sensors
      powertop

      #############################
      # Scripting
      #

      # Most scripts in the dotfile repo rely on these.
      # Do not remove or change!
      bash
      bc
      python3

      #############################
      # Commonly used tools
      #

      ripgrep         # fast grep, aka rg
      fd              # nice find replacement
      fzf             # fuzzy finder

      ncdu            # disk usage utility

      git # No git, no dotfiles, no nothing.
      mr

      imagemagick
      ghostscript # needed for imagemagick and pdf stuff

      unrar
      unzip
      zip

      pwgen
      pass
    ]
    # Graphical tools only if the Xserver is enabled
    ++ (if config.services.xserver.enable then
      [
        # parted frontend
        gparted
      ]
    else
      [ ]);
}
