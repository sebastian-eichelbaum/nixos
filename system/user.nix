# #############################################################################
# User Setup
#

{ config, pkgs, ... }:

let
  name = "Sebastian";
  user = "seb";
in {
  # Ensure ZSH install as it is the default shell
  programs.zsh = {
    enable = true;
    # This enables completions for the nix tools.
    enableCompletion = true;

    # Users have their own zshrc and init completion there. Leaving this on can
    # cause a significantly increased load time and allows to extend fpath with
    # custom completers.
    enableGlobalCompInit = false;
  };

  # Install some shell wrappers.
  environment.systemPackages = with pkgs;
    [
      # Do not use programs.starship. It does not load my custom config
      starship
    ];

  # Automatically add ~/.local/bin to path. REQUIRED as my dotfile setup
  # relies on this.
  environment.localBinInPath = true;

  # Prevent any user modifications, including add/remove, change groups,
  # passwd, ...
  # You can still modify the group and user lists, but they will be overwritten
  # by the next rebuild.
  users.mutableUsers = false;

  # Default user present on all systems:
  users = {
    # Ensure zsh is the default everywhere
    defaultUserShell = pkgs.zsh;

    # The user gets its own group
    groups."${user}" = {
      name = "${user}";
      gid = 1000;
    };

    # Create the user
    users = {
      "${user}" = {
        # Has to be set. This makes the user a non-root-like user. Ensures the
        # home dir is created and the default shell is used.
        isNormalUser = true;

        description = "${name}";

        home = "/home/${user}";
        homeMode = "755";
        uid = 1000;

        # Groups for the user. The "group" is the fmain group and will be the
        # group that owns the home dir.
        group = "${user}";
        extraGroups = [
          # Be a user
          "users"
          # Also allow sudo
          "wheel"

          # The usual "make the PC actually configurable"-groups:
          "networkmanager"
          "audio"
          "video"
          "plugdev"
          "input"

          # Allow virtualization 
          "libvirtd"
          "vboxusers"
        ];

        # Overwrite the default shell?
        # shell = pkgs.zsh;

        # The password is set in /etc/nixos/users.nix. The file does not exist
        # by default. Create and fill according to the README.md
        # hashedPassword = "...";

        # Default public ssh keys can be specified that are allowed to log in via
        # SSH.
        #openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3Nza... alice@foobar" ];
      };

      root = { };
    };
  };
}
