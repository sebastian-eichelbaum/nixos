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
    bat-extras.batgrep
    tree # Dir tree previews in fzf
    delta # Pager and Diff highlighter. Used with git.

    ###########################################################################
    # Tools
    #

    lazygit # Nice git history browser
    mr # repo management
    mani # repo management. Nice replacement for mr.

    ncdu # disk usage utility

    # Password management
    pwgen
  ];

  #############################################################################
  # Direnv: allows to automatically activate environemnts like devbox when
  #         cd-ing into a dir.
  #         Add .envrc to a dir and it will be parsed automatically.

  programs.direnv = {
    enable = true;
    # Less noisy
    silent = true;
    # Faster, cached and persistent use_nix/use_flake. This keeps installed
    # shells even after garbage collection has been run.
    nix-direnv.enable = true;

    # Define some global settings.
    # ATTENTION: the direnv packages has a history of ignoring these settings for some reason. There are several issue
    # reports on their github regarding this. You might want to add these settings to your ~/.config/direnv/direnv.toml
    # too. Just in case ;-)
    settings = {
      global = { warn_timeout = "5m"; };
      whitelist = {
        prefix = [ "~/Projekte" "~/Projects" "~/Dokumente/" "~/Documents" ];
      };
    };
  };
}
