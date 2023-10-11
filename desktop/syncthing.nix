{ config, lib, pkgs, ... }:

let user = "seb";
in {
  #############################################################################
  # Syncthing
  #

  services.syncthing = {
    enable = true;
    systemService = true;

    # Run as the main user
    user = user;
    group = user;

    # Assume everything to be in the users home
    dataDir = "/home/${user}";
    configDir = "/home/${user}/.config/syncthing";

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

      # Allow to announce the insatance in the local network. This enables other
      # devices to pick this one up.
      options.localAnnounceEnabled = true;

      devices = {
        # This is an introducer. It will automatically provide its known devices 
        # to us. So we only need to list this one here.
        #
        # To manage the server: 
        #   * ssh -L 9092:localhost:8384 seb@server_url 
        #   * Browse to localhost:9092
        "Server" = {
          # Never changes if the original key and cert is kept
          id =
            "MHSDFSN-SSRPIPP-EXHAMWL-235UB5E-YCZZYYX-R5CCHG6-OHD4S7M-KXP5GQJ";
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
