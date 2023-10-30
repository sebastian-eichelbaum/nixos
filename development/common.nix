{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Development: Common tools
  #

  # Handy shell local environment handler.
  programs.direnv = {
    enable = true;
    silent = true;
  };

  environment.systemPackages = with pkgs; [
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

    ##################################################
    # Local coding environemnt basics:

    devbox

    # Devenv recommends cachix as everything is build from source.
    # (import (fetchTarball https://install.devenv.sh/latest)).default
  ];
}
