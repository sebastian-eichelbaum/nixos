# ############################################################################
# The base setup for all desktops
#

{ config, lib, pkgs, ... }:

let user = "seb";
in {

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
        rev = "0e5fc45";
        # Set this. Nix will complain and show the real hash
        #sha256 = "sha256:0000000000000000000000000000000000000000000000000000";
        sha256 = "sha256-ZFjYKyzQiRgg5uHgMLeex6oOKDrXMhp9dxxHEm2xeH4=";
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

  # Compositing. NOTE: this provides picom as sustemd service but does not allow
  # to load a custom config file in $HOME
  services.picom.enable = true;

  # Clipboard manager
  services.greenclip.enable = true;

  # Light control
  programs.light.enable = true;

  # The GPG agent to store unlocked keys per session
  programs.gnupg.agent.enable = true;

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
    pinentry-gnome

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
      "/home/${user}/.local/bin/mon-backlight-dimmer"
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
