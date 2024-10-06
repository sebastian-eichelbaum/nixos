{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Automatic screen management: autorandr
  #

  # Needed by those scripts
  environment.systemPackages = with pkgs; [ xorg.xdpyinfo libnotify ];

  services.autorandr = {
    enable = true;

    # Define some default hooks that inform the user about what is going on.
    hooks = {

      # predetect = {
      #   "notify" = ''
      #     ${pkgs.libnotify}/bin/notify-send -a "Autorandr" -i display -r "154334" "Display Profile" "Detecting ..."
      #   '';
      # };
      #
      # preswitch = {
      #   "notify" = ''
      #     ${pkgs.libnotify}/bin/notify-send -a "Autorandr" -t 5000 -i display -r "154334" "Display Profile" "<b>$AUTORANDR_MONITORS</b> > $AUTORANDR_CURRENT_PROFILE"
      #   '';
      # };

      # The sleep is required. A window manager might restart, killing the notification window.
      postswitch = {
        "01_dpi" = ''
          # Get the DPI set by randr
          xdpi=`xdpyinfo | grep "dots per inch" | awk '{print $2;}' | grep -o "[[:digit:]]\+x" | cut -d"x" -f1`

          # Ensure a sane default
          if [ -n "$xdpi" ] && [ "$xdpi" -eq "$xdpi" ] 2>/dev/null; then
            echo "Setting DPI from xdpyinfo/randr: $xdpi"
          else
            xdpi="96"
            echo "Setting DPI default: $xdpi"
          fi

          # xsettings wants dpi*1024
          xsettingsDPI=$(( 1024*xdpi ))

          # Push to the Xresourses DB. Do not fail.
          echo "Xft.dpi: $xdpi" | ${pkgs.xorg.xrdb}/bin/xrdb -merge || true

          # Push to xsettingsd. Ensure it exists and ensure it is not empty (size=0 via [-s])
          mkdir -p $HOME/.config/xsettingsd/
          fn="$HOME/.config/xsettingsd/xsettingsd.conf"
          [ -s $fn ] || echo " " > $fn
          sed -i -n -e '/^Xft\/DPI /!p' -e "\$aXft\/DPI $xsettingsDPI" $fn

          # Restart the xsettingsd service
          systemctl --user restart xsettingsd.service
        '';
        "90_restartDunst" = "systemctl --user restart dunst.service";
        "99_notify" = ''
          ${pkgs.libnotify}/bin/notify-send -a "Autorandr" -t 5000 -i display -r "154334" "Display Profile" "<b>$AUTORANDR_MONITORS</b> > $AUTORANDR_CURRENT_PROFILE"
        '';
      };
    };

    defaultTarget = "common";

    # Enabling this is helpful when using nvidia-only or prime configs. The actual name of the output will change in
    # those configs. The fingerprints stay the same.
    #
    # Run autorandr --match-edid to see how it works
    matchEdid = true;

    profiles = {
      "Mobile" = {
        fingerprint = {
          "eDP-1" =
            "00ffffffffffff000e6f24160000000000200104a5221678030f98ae5243b0260f515500000001010101010101010101010101010101c07200a0a040c8603020360058d710000018000000fd0c3cf0b1b176010a202020202020000000fe0043534f542054330a2020202020000000fe004d4e473030374441342d310a20017d701279000003012800cb0185ff099f002f001f003f06c7000200050067130105ff099f002f001f003f06c700020005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006890";
        };
        config = {
          "eDP-1" = {
            enable = true;
            primary = true;
            mode = "2560x1600";
            position = "0x0";
            rate = "144"; # Lower rate saves roughly 1W power on idle.
            dpi = 120;
          };
        };
      };

      "Docked" = {
        fingerprint = {
          "eDP-1" =
            "00ffffffffffff000e6f24160000000000200104a5221678030f98ae5243b0260f515500000001010101010101010101010101010101c07200a0a040c8603020360058d710000018000000fd0c3cf0b1b176010a202020202020000000fe0043534f542054330a2020202020000000fe004d4e473030374441342d310a20017d701279000003012800cb0185ff099f002f001f003f06c7000200050067130105ff099f002f001f003f06c700020005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006890";
          "DP-5" =
            "00ffffffffffff001e6dd25b20b70000041f010380462778ea8cb5af4f43ab260e5054210800d1c06140010101010101010101010101e9e800a0a0a0535030203500b9882100001a000000fd0030901ee63c000a202020202020000000fc004c4720554c545241474541520a000000ff003130344e54504331433838300a013102034cf1230907074d100403011f13123f5d5e5f60616d030c001000b83c20006001020367d85dc401788003e30f00186d1a0000020430900004614f614fe2006ae305c000e606050161614f6fc200a0a0a0555030203500b9882100001a565e00a0a0a0295030203500b9882100001a000000000000000000000000000000e8";
        };
        config = {
          "eDP-1" = {
            enable = false;
            primary = false;
          };
          "DP-5" = {
            enable = true;
            primary = true;
            mode = "2560x1440";
            position = "0x0";
            rate = "120";
            dpi = 96;
          };
        };
      };
    };
  };
}

