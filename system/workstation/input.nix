{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Keyboard Setup
  #

  # Configure keymap in X11 to match
  services.xserver.xkb.layout = "eu";
  services.xserver.xkb.options = "terminate:ctrl_alt_bksp,ctrl:nocaps";

  # Key repeat interval and repeat rate
  services.xserver.autoRepeatInterval = 33;
  services.xserver.autoRepeatDelay = 300;

  console = {
    #font = "Lat2-Terminus16";
    #earlySetup = true;

    # The keymap could be derived from xkb config if it uses a keymap that is
    # supported on the console. As "eu" is used, which is not supported on the
    # console, set "us" instead:
    # useXkbConfig = true; # use xkbOptions in tty.
    keyMap = "us";
  };

  #############################################################################
  # Mouse and Touchpad Setup
  #

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;

    # Touchpad configuration. A lot of options are available. The defaults
    # are very good.
    touchpad = {
      # NEVER use the inverted scroll
      naturalScrolling = false;

      # Disable the touchpad while typing?
      # Keep in mind: palm-rejection works quite well
      disableWhileTyping = true;
    };
  };

  #############################################################################
  # Gesture Support
  #

  # Install and start per session
  environment.systemPackages = with pkgs; [ libinput-gestures ];
  services.xserver.displayManager.sessionCommands = ''
    libinput-gestures &
  '';

}
