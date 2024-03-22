# ############################################################################
# The base setup for all desktops
#

{ config, lib, pkgs, ... }:

{

  #############################################################################
  # {{{ Awesome
  #

  # Build the latest awesome
  services.xserver.windowManager.awesome = {
    enable = true;
    package = pkgs.awesome.overrideAttrs (old: {
      src = pkgs.fetchFromGitHub {
        owner = "awesomeWM";
        repo = "awesome";
        rev = "e6f5c7980862b7c3ec6c50c643b15ff2249310cc";
        # Set this. Nix will complain and show the real hash
        #sha256 = "sha256:0000000000000000000000000000000000000000000000000000";
        sha256 = "sha256-afviu5b86JDWd5F12Ag81JPTu9qbXi3fAlBp9tv58fI=";
      };

      patches = [ ];

      # Man and doc generation fails right now
      cmakeFlags = old.cmakeFlags
        ++ [ "-DGENERATE_MANPAGES=OFF" "-DGENERATE_DOC=off" ];
    });
  };

  # }}}

  #############################################################################
  # {{{ Services and background programs to run per desktop session
  #

  # Clipboard manager
  services.greenclip.enable = true;

  # Light control
  programs.light.enable = true;

  # The GPG agent to store unlocked keys per session
  programs.gnupg.agent.enable = true;

  # Compositing. NOTE: this has some drawbacks:
  #  * does not load a config file in $HOME
  #  * BUG: systemd service gone missing?!
  #services.picom = {
  #  # Disabled. Too many issues. Installed as a package instead
  #  enable = false;
  #  settings = {
  #    # vsync = false;
  #    # ...
  #  };
  #};

  # }}}

  #############################################################################
  # {{{ Desktop baseline programs
  #

  # Enable firefox by default.
  programs.firefox.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    # Nice terminal
    kitty

    # xranr frontend
    arandr

    # Notifications
    dunst
    libnotify

    # Launchers
    rofi
    rofi-pass

    # Allow to ask for passwords graphically
    pinentry-gnome3

    # Nice screen locker
    xss-lock
    i3lock-fancy-rapid
  ];

  # Make kitty the default for those that respect the TERMINAL variable
  environment.variables = { TERMINAL = "${pkgs.kitty}/bin/kitty"; };

  # }}}

  #############################################################################
  # {{{ Locking, Dimming an DPMS
  #

  # xss-lock as the locking service
  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 5 5";
    extraOptions = [
      # Use this custom dimmer script when notifying the
      # user about inactivity.
      #
      # The good thing: if the script is not present, xss-lock does nothing.
      "-n"
      "/home/${config.SysConfig.user.name}/.local/bin/mon-backlight-dimmer"
    ];
  };

  # To configure the lock timeouts, use xset:
  services.xserver.displayManager.sessionCommands = ''
    # Enable DPMS and set timeouts
    xset +dpms
    xset dpms 600 600 600

    # Start blank after 180s, lock after additional 4xx seconds.
    #
    # The first number is the noification period. xss-lock
    # calls its notifier in that case. It is used to dim the
    # screen. If xss-lock is not running, the screen blanks.
    #
    # The second number triggers after the notification and
    # usually locks.
    xset s 180 400
  '';

  # }}}
}
