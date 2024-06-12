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

  programs.direnv = {
    enable = true;
    # Less noisy
    silent = true;
    # Faster, cached and persistent use_nix/use_flake. This keeps installed
    # shells even after garbage collection has been run.
    nix-direnv.enable = true;
  };

  # Nixos rewrites DIRENV_CONFIG to /etc/direnv - this causes ~/.config/direnv/direnv.toml
  # not being found. We can configure some common options in etc though:
  environment.etc = {
    # Creates /etc/nanorc
    "direnv/direnv.toml" = {
      text = ''
        [global]
        warn_timeout = "3m"

        [whitelist]
        prefix = [ "~/Projekte", "~/Projects" ]
      '';

      # The UNIX file mode bits
      mode = "0444";
    };
  };
}
