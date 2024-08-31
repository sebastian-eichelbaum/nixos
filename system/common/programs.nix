{ config, lib, pkgs, ... }:

{
  # ATTENTION: this defines some BASIC system packages that are assumed to be
  # useful for all users, especially while administrating NixOS.

  # DO NOT add user specific packages. This is the base-line system.

  #############################################################################
  # System packages
  #

  # Install some sane default programs for system management.
  environment.systemPackages = with pkgs;
    [
      # Utils, monitoring and hardware tools

      psmisc # fuser, killall, pstree, ...
      htop # better monitoring of cpu/mem and IO
      file

      pciutils
      usbutils
      smartmontools
      lm_sensors

      # Get stuff onto and from the machine
      wget
      curl
      rsync

      # Some archivers. Although installed by default, make sure they are in our system path.
      gnutar
      gzip
      bzip2
      unzip
      zip

      # Baseline for most scripts. Do not remove or change!
      bash
      bc
      python3

    ]
    # Vim only if neovim is not explicitly enabled.
    # NOTE: please leave this. If you ever forget to add an editor, you
    #       would not be able to edit any config. This ensures there is
    #       at least vim installed.
    ++ pkgs.lib.optionals (!config.programs.neovim.enable) [
      # We need to ensure an editor is installed or editing the config would not be possible.
      vim
    ];

  # Git is mandatory on all systems:
  programs.git = {
    enable = true;
    # Modern git uses main instead of master
    config = { init = { defaultBranch = "main"; }; };
  };

  #############################################################################
  # Editor
  #

  # Use NeoVim as the default editor. No editor, no NixOs config changes ;-)
  programs.neovim = {
    enable = lib.mkDefault true;
    defaultEditor = lib.mkDefault true;

    # Alias vi and vim to neovim
    vimAlias = lib.mkDefault true;
    viAlias = lib.mkDefault true;

    # Runtimes: As the common setup aims for a minimal install - they are disabled by default.
    withNodeJs = lib.mkDefault false;
    withPython3 = lib.mkDefault false;
    withRuby = lib.mkDefault false;

    # Unwrapped version
    package = lib.mkDefault pkgs.neovim-unwrapped;
  };

  # Also tell everyone else that (n)vim is THE editor
  # Hint: when setting programs.neovim.vimAlias to true, this refers to nvim then.
  environment.variables = {
    EDITOR = lib.mkDefault "vim";
    VISUAL = lib.mkDefault "vim";
  };
}
