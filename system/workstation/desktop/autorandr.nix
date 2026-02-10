{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Automatic screen management: autorandr
  #

  # Needed by those scripts
  environment.systemPackages = with pkgs; [ xdpyinfo libnotify ];

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
          echo "Xft.dpi: $xdpi" | ${pkgs.xrdb}/bin/xrdb -merge || true

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
    # Run autorandr --fingerprint to get the fingerprints of your current setup
    matchEdid = true;

    # You can define profiles here. But as they are hardware specific, this is done in the machine configuration!
    #profiles = { ... };
  };
}

