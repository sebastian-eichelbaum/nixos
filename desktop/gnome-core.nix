{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Gnome Core
  #

  services.xserver.desktopManager.gnome = {
    enable = true;

    # Add some GSettings and custom overrides? Be careful. There are some
    # issues. I.e.:
    # * changing this value is usually set once during first install.
    # If the user overrides it, it is ignored.
    # * This defines the default value only.
    #
    # See https://nixos.org/manual/nixos/unstable/#sec-gnome-gsettings-overrides

    # Allows to set a string to override settings.
    extraGSettingsOverrides = ''
      # Change default terminal for  nautilus-open-any-terminal
      [com.github.stunkymonkey.nautilus-open-any-terminal]
      terminal='kitty'
    '';

    # If a settings should be overwritten in extraGSettingsOverrides, the package
    # that provides the schema must be listed hereL
    extraGSettingsOverridePackages = with pkgs;
      [
        # A nice way to use a custom terminal for nautilus
        nautilus-open-any-terminal
      ];
  };

  # Configure Gnome services. This allows some detailed settings what to use
  # and what not to use.
  services.gnome = {
    # All the core stuff. These are REQUIRED. Refer to the docs to see a full list.

    # core-shell.enable = false;
    # core-utilities.enable = false;
    # core-os-services.enable = false;
    # glib-networking.enable = false;
    # gnome-keyring.enable = false;
    # gnome-settings-daemon.enable = false;
    # tracker.enable = false;
    # tracker-miners.enable = false;
    # gnome-online-miners.enable = false;

    ############################
    # Disable

    # The nautilus preview tools
    sushi.enable = false;

    # An UPNP Mediaserver
    rygel.enable = false;

    # User-level shares
    gnome-user-share.enable = false;

    # Online accounts
    gnome-online-accounts.enable = false;

    # Remote Desktop
    gnome-remote-desktop.enable = false;

    # Setup assitant
    gnome-initial-setup.enable = false;

    # Allow browsers to install shell extensions?
    gnome-browser-connector.enable = false;

    # The games
    games.enable = false;

    # Dev tools
    core-developer-tools.enable = false;

    # Evolution
    evolution-data-server.plugins = lib.mkForce false;
    evolution-data-server.enable = lib.mkForce false;

    # Assistive tools
    at-spi2-core.enable = lib.mkForce false;
  };

  # Exclude all those nasty gnome apps:
  environment.gnome.excludePackages =
    # Some packages are not part of pkgs.gnome.
    (with pkgs; [ gnome-photos gnome-tour gnome-text-editor ])
    ++ (with pkgs.gnome; [
      baobab # disk usage analyzer
      cheese # photo booth
      #eog         # image viewer
      epiphany # web browser
      gedit # text editor
      simple-scan # document scanner
      #totem       # video player
      yelp # help viewer
      #evince      # document viewer
      #file-roller # archive manager
      geary # email client
      # seahorse # password manager
      # these should be self explanatory
      gnome-terminal
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-contacts
      #gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-screenshot
      gnome-system-monitor
      gnome-weather
      gnome-disk-utility
      pkgs.gnome-connections
    ]);

  #############################################################################
  # Additional Gnome-Specific Apps
  #

  environment.systemPackages = with pkgs; [
    # An authentication agent is required for those nice password prompts.
    polkit_gnome

    # Tweak some settings for gnome apps and gtk?
    # Attention: most of the theming settings are IGNORED since Gnome 43.
    # gnome.gnome-tweaks

    # gsettings editor
    gnome.dconf-editor

    # Support python-based Nautilus extensions
    gnome.nautilus-python

    # Allows to open an arbitrary terminal instead of kgx (gnome terminal)
    # Configure via
    # gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
    nautilus-open-any-terminal
    rabbitvcs
  ];

  # Required for some apps to work (to be able to query settings)
  programs.dconf.enable = true;

  #############################################################################
  # Polkit Agent Setup
  #

  # Unfortunately, its xdg autostart only runs on gnome directly. Use a simple
  # systemd service to fix that for other window managers
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
