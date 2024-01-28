{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    ###########################################################################
    # CLI baseline
    # - all the CLI tools I use regularly or are part of my dotfile setup
    #

    ###########################################################################
    # Shell
    #

    # NOTE: these tools are usually intertwined. Removing one will probably break the others.
    ripgrep # fast grep, aka rg
    fd # nice find replacement
    fzf # fuzzy finder
    bat # Cat replacement with colors
    tree # Dir tree previews in fzf
    delta # Pager and Diff highlighter. Used with git.

    ###########################################################################
    # Tools
    #

    lazygit # Nice git history browser
    mr # repo management

    ncdu # disk usage utility

    # Password management
    pwgen
    pass
  ];

  #############################################################################
  # Direnv: allows to automatically activate environemnts like devbox when
  #         cd-ing into a dir.
  #         Add .envrc to a dir and it will be parsed automatically.
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

}
