{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Direnv: allows to automatically activate environemnts like devbox when
  #         cd-ing into a dir.
  #
  # It requires some config though. Add a direnv.toml to ~/.config/direnv and
  # refer to the man page.

  programs.direnv = {
    enable = true;
    silent = true;
  };

  # WARNING: currently, ~/.config/direnv/direnv.toml is ignored in NixOS. To
  #          make this work, you have to set DIRENV_CONFIG:
  environment.shellInit = ''
    DIRENV_CONFIG="$HOME/.config/direnv"
  '';

  #############################################################################
  # Development: Common tools
  #

  environment.systemPackages = with pkgs; [

    # Company fonts - I use these for some work-related things
    montserrat
    raleway

    #############################
    # Editors
    #

    # NOTE: vim/neovim are configured by the NixOS system config
    vscode

    #############################
    # Standard tools
    #

    gnumake

    # Git and git related UI tools
    git
    gittyup
    meld
    lazygit

    ##################################################
    # Local coding environemnt basics:

    devbox

    # Devenv recommends cachix as everything is build from source.
    # (import (fetchTarball https://install.devenv.sh/latest)).default
  ];
}
