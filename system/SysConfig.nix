# Creates a small module that allows to set all system specific user options and secrets

{ lib, ... }:

{
  options = {
    ###########################################################################
    # System
    #

    SysConfig.stateVersion = lib.mkOption {
      type = lib.types.str;
      description =
        "The nixos state version. Check https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion for detail";
      # WARNING: do not define a default here. If this default ever changes, all
      # systems that rely on that default might break!
    };

    SysConfig.hostName = lib.mkOption {
      type = lib.types.str;
      description = "System hostname";
    };

    SysConfig.machine = lib.mkOption {
      type = lib.types.str;
      description =
        "The Nix module that declares the machine itself. Hardware, boot, harddisk setup, ...";
    };

    ###########################################################################
    # Main User
    #

    SysConfig.user = {
      realName = lib.mkOption {
        type = lib.types.str;
        description = "The main user's real name";
        default = "Sebastian";
      };

      name = lib.mkOption {
        type = lib.types.str;
        description = "The main user's login name";
        default = "seb";
      };

      passHash = lib.mkOption {
        type = lib.types.str;
        description =
          "The main user's password hash. Use mkpasswd to generate.";
      };

      extraGroups = lib.mkOption {
        type = lib.types.listOf (lib.types.str);
        default = [ ];
        description = "The main user's additional groups.";
      };
    };

    ###########################################################################
    # Root user
    #

    SysConfig.root.passHash = lib.mkOption {
      type = lib.types.str;
      description = "The root user's password hash. Use mkpasswd to generate.";
    };

    ###########################################################################
    # Features:
    #

    ### Syncthing:

    # A shared Syncthing configuration and a common server is used among all machines.
    # It is on if a server device ID is specified. If not, syncthing will be disabled completely.
    SysConfig.syncthing.serverId = lib.mkOption {
      type = lib.types.str;
      description = "Syncthing main server to use on this system.";
      default = "";
    };
  };
}
