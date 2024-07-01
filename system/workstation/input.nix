{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Keyboard Setup
  #

  # Configure keymap in X11 to match
  # services.xserver.xkb.layout = "eu";
  services.xserver.xkb.layout = "eu-cursors";
  # Options:
  #  * ctrl:nocaps - disabled capslock and maps it to left control
  #  * caps:hyper - maps caps to the Hyper modifier
  #  * lv3:caps_switch - maps caps to altgr (level3)
  services.xserver.xkb.options = "terminate:ctrl_alt_bksp,lv3:caps_switch";

  # Embedd additional layouts:
  #  When modifying these, test first to avoid X11 startup failures:
  # nix-shell -p xorg.xkbcomp && setxkbmap -I/yourpath us-greek -print | xkbcomp -I/yourpath - $DISPLAY
  services.xserver.xkb.extraLayouts.eu-cursors = {
    description =
      "EurKey Layout with Cursors+AltGr(or Caps) mapped to home/end/PgUp/PgDn";
    languages = [ "eng" ];
    symbolsFile = pkgs.writeText "eu-cursors" ''
      xkb_symbols "eu-cursors"
      {
        include "eu"

        // Modify the EurKey Layout to map AltGR-Left/Right/Up/Down to Home/End/PgUp/PgDown
        // Hint: specify "lv3:caps_switch" in your kbb options to use caps as alt-gr.
        // or: 
        include "level3(caps_switch)"

        key <LEFT> {
                 type= "THREE_LEVEL",
                 symbols[Group1] = [ Left, Left, Home ]
                 // Disables key repeat wen set in services.xserver.xkb.layout ??!!
                 // actions[Group1] = [ NoAction(), NoAction(), RedirectKey(keycode=<HOME>, clearmods=levelThree) ]
        };
        key <RGHT> {
                 type= "THREE_LEVEL",
                 symbols[Group1] = [ Right, Right, End ]
                 // actions[Group1] = [ NoAction(), NoAction(), RedirectKey(keycode=<END>, clearmods=levelThree) ]
        };
        key <UP> {
                 type= "THREE_LEVEL",
                 symbols[Group1] = [ Up, Up, Next ]
                 // actions[Group1] = [ NoAction(), NoAction(), RedirectKey(keycode=<PGUP>, clearmods=levelThree) ]
        };
        key <DOWN> {
                 type= "THREE_LEVEL",
                 symbols[Group1] = [ Down, Down, Prior ]
                 // actions[Group1] = [ NoAction(), NoAction(), RedirectKey(keycode=<PGDN>, clearmods=levelThree) ]
        };
      };
    '';
  };

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
