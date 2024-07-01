{ config, lib, pkgs, ... }:

{
  # Use awesome as the default for new systems.
  services.xserver.windowManager.awesome.enable = lib.mkDefault true;

  #############################################################################
  # X and Login
  #

  # Configure the X server
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Log file? By default, Nix disables this to force x log to the journal.
    # logFile = "/var/log/Xorg.0.log";

    # Login manager
    displayManager = {

      /* # Use GDM
         gdm = {
           enable = true;

           # Disable Wayland.
           wayland = false;

           # Do not autosuspend when idle
           autoSuspend = false;
         };
      */

      # Use LightDM
      lightdm = {
        enable = true;

        # Use the background of the user
        background = "/home/${config.SysConfig.user.name}/.background-image";

        # Theme
        #greeters.slick.enable = true;
        #greeters.slick.draw-user-backgrounds = true;
        greeters.enso.enable = true;
        greeters.enso.blur = true;
      };

    };
  };

  # Configure Login and display manager
  services.displayManager = {
    # Auto Login
    autoLogin.enable = true;
    autoLogin.user = config.SysConfig.user.name;

    # The default session if the user has not yet made a decision
    #defaultSession = "gnome-xorg";
    defaultSession = "none+awesome";

  };

  #############################################################################
  # GPU
  #

  # Enable OpenGL by default.
  # Right now, this also covers vdpau and opencl. NOT covered
  hardware.graphics = {
    enable = lib.mkDefault true;

    # For steam and some proprietary games
    enable32Bit = true;

    # OpenCL and vdpau are enabled by default too. Use:
    #  * nix-shell -p vdpauinfo --run vdpauinfo
    #  * nix-shell -p opencl-info --run opencl-info
    #  * nix-shell -p libva-utils --run vainfo
    # to check and validate.

    # To enable hardware specific vaapi video decoding: check the machine specific config!
    extraPackages = with pkgs;
      [
        # Allow VDPAU to use VAAPI
        libvdpau-va-gl

        # Allow VAAPI to use VDPAU drivers? Consider this when uzing proprieatary
        # NVIDIA drivers
        # vaapiVdpau
      ];

  };

  # Enable VAAAPI as backend for VDPAU? Be careful. If an nvidia card is present,
  # VDPAU can utilize that directly.
  # environment.variables = { VDPAU_DRIVER = lib.mkDefault "va_gl"; };

  #############################################################################
  # Some default tools and settings
  #

  # Add some common X tools
  environment.systemPackages = with pkgs; [
    # Xorg base tools (some commonly used subset of them)
    xorg.xmessage # print messages. Used for errors in early setup stages.
    xorg.xev # xev - the x event debugger
    xorg.xset # xset - the x settings tool
    xorg.xrdb # xrdb - the Xresources/Xdefaults tool
    xorg.xkill # xkill - the graphical program killer
    xorg.xprop # xprop - print X properties of windows
    xorg.xrandr # xrandr - the physical display manager
    xorg.xsetroot # xsetroot - set root window. required by some WM setups
    xorg.setxkbmap # setxkbmap - modify the keymap used in X

    xclip # clipboard provider. Needed for vim/greenclip/...
    xdotool # Programmatically perform X ops. Needed for rofi-pass/...

    xcalib # handy tool to set display color calibration files.
  ];

  # Disable the annoying bell.
  # NOTE: most terminals still ring the bell. They have specific settings to
  # turn this off.
  xdg.sounds.enable = false;
  services.xserver.displayManager.sessionCommands = ''
    # Disable bell
    xset b off

    # load Xresources if present
    if [ -f $HOME/.Xresources ]; then
      xrdb -merge $HOME/.Xresources
    fi
  '';
}
