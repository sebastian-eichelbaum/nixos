{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Syncthing
  #

  services.syncthing = lib.mkIf (config.SysConfig.syncthing.serverId != "") {
    enable = true;
    systemService = true;

    # Run as the main user
    user = config.SysConfig.user.name;
    group = config.SysConfig.user.name;

    # Assume everything to be in the users home
    # NOTE: data dir will contain the index db.
    dataDir = "/home/${config.SysConfig.user.name}/.config/syncthing";
    configDir = "/home/${config.SysConfig.user.name}/.config/syncthing";

    # Open FW for Syncthing
    openDefaultPorts = true;

    # GUI Access?
    guiAddress = "127.0.0.1:8384";

    # Allow the user to modify folders and device lists?
    overrideFolders = true;
    overrideDevices = true;

    settings = {
      # No usage stats allowed
      options.urAccepted = -1;

      # Enable relays - uses the global relays
      options.relaysEnabled = true;

      # Allow to announce the instance in the local network. This enables other
      # devices to pick this one up.
      options.localAnnounceEnabled = true;

      devices = {
        # This is an introducer. It will automatically provide its known devices
        # to us. So we only need to list this one here.
        #
        # To manage the server:
        #   * ssh -L 9092:localhost:8384 USERNAME@server_url
        #   * Browse to localhost:9092
        "Server" = {
          # Never changes if the original key and cert is kept
          id = config.SysConfig.syncthing.serverId;
          introducer = true;
        };
      };

      folders = {
        "Shared" = {
          versioning.type = "simple";
          versioning.params = { keep = "3"; };
          path = "~/Shared";
          devices = [ "Server" ];
        };
        "Handyfotos" = {
          versioning.type = "simple";
          versioning.params = { keep = "3"; };
          path = "~/Fotos/Handyfotos";
          devices = [ "Server" ];
        };
      };
    };
  };
}
