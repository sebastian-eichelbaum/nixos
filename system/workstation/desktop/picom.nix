{ config, pkgs, lib, ... }:

{
  # Compositing.
  #
  # NOTE: this provides picom as sustemd service but does not allow
  # to load a custom config file in $HOME
  #
  # NOTE: picom service is not starting? systemctl --user status picom
  # complains the service file not being found? Delete the link
  # ~.config/systemd/user/picom.service
  #
  # See https://github.com/yshui/picom/blob/next/picom.sample.conf
  services.picom = {

    enable = true;

    # Settings. Refer to picom manual for details.
    settings = {

      log-level = "warn";

      # The backend to use. This influences vsync functionality and blur
      #backend = "xrender";
      backend = "glx";

      # Makes workspace flips and fast moving stuff look good but increases latency
      # You "feel" it being slower.
      vsync = false;

      # Full-screen opaque, focussed windows are unredirected (not handled by the compositor).
      # Improves performance on fullscreen games.
      unredir-if-possible = true;

      # If both are true, grouped windows (child windows in a owning parent) are
      # handled as focussed/active at the same time. If false, you can make parent
      # windows dim or transparent if a child opens.
      detect-transient = true;
      detect-client-leader = true;

      # Only redraw changed parts of the screen
      use-damage = true;

      # Performance? Refer to picom manual for details.
      glx-no-stencil = true;
      glx-no-rebind-pixmap = true;

      #########################################################################
      # Fading
      #

      fading = true;
      fade-in-step = 0.1;
      fade-out-step = 0.1;
      fade-delta = 10;

      # Do not fade on window open/close.
      no-fading-openclose = false;

      # Specify a list of conditions of windows that should not be faded.
      fade-exclude = [
        # Prevents fullscreen active windows to flicker
        # "focused"

        # Exclude all but ROFI. It looks nice :-)
        "window_type = 'normal' && class_g != 'Rofi'"
      ];

      #########################################################################
      # Corners
      #

      # corner-radius = 10;

      #########################################################################
      # Shadows
      #

      shadow = true;
      shadow-offset-x = -50;
      shadow-offset-y = -50;
      shadow-opacity = 0.66;
      shadow-radius = 50;

      # Exclude some types of windows as they create strange artefacts
      shadow-exclude = [
        "window_type != 'dock' && !focused"

        "_GTK_FRAME_EXTENTS@"
        # Firefox creates strange borders around menus. Disable shadows for FF
        "class_g = 'Firefox' && argb"
        "class_g = 'firefox' && argb"
        # Qt Apps nutzen manchmal eigene styles und runde menus usw.
        "_NET_WM_WINDOW_TYPE *= '_KDE_NET_WM_WINDOW_TYPE_OVERRIDE'"
      ];

      #########################################################################
      # Transparency
      #

      # NOTE: most of this is handled by GTK, Qt and the Windowmanager anyways.
      # inactive-opacity = 0.9;
      # active-opacity = 0.9;
      # frame-opacity = 0.9;
      # menu-opacity = 0.9;

      # Can look nice but causes a flicker for grouped windows sometimes if the child window closes.
      # NOTE: when using a color picker, the color picker picks up the dimmed color for inactive windows.
      # inactive-dim = 7.5e-2;

      # Let inactive opacity set by -i override the '_NET_WM_OPACITY' values of windows.
      # If true, picom overrides the settings provided by the window manager
      inactive-opacity-override = false;

      #########################################################################
      # Blur
      #

      # Disable blur by commenting out these lines. Some blur methods only work with GLX as backend
      blur = {
        method = "dual_kawase";
        strength = 3;
      };

      # Transparent window blur. Attention: might have some performance impact.
      blur-background = true;
      # Blur frames? Should be false. Tooltips in firefox have a frame that looks strange when blurring.
      blur-background-frame = false;

      # Exclude some types of windows as they create strange artefacts
      blur-background-exclude = [
        # Disable for all windows except rofi?
        #"window_type = 'normal' && class_g != 'Rofi'"

        # Disable for some window types and GTK Frames.
        "_GTK_FRAME_EXTENTS@"
        #"window_type = 'dock'"
        "window_type = 'desktop'"
        "window_type *= 'menu'"
      ];

      #########################################################################
      # Window type specific overrides
      #

      # Not yet supported by nix. Produces a badly formatted rules definition
      # rules = [
      #   {
      #     match = "window_type = 'tooltip'";
      #     blur = false;
      #   },
      #   {
      #     match =
      #       "window_type = 'dock' ||  window_type = 'desktop' || _GTK_FRAME_EXTENTS@";
      #     blur-background = false;
      #   },
      #   {
      #     match = "window_type = 'dock' || window_type = 'desktop'";
      #     corner-radius = 0;
      #   }
      # ];

      wintypes = {
        # GTK4 messes with those shadows
        menu = {
          fade = true;
          shadow = false;
          full-shadow = true;
          opacity = 1.0;
          focus = true;
        };
        dropdown_menu = {
          fade = true;
          shadow = true;
          opacity = 0.95;
          focus = true;
        };
        popup_menu = {
          fade = true;
          shadow = true;
          opacity = 0.95;
          focus = true;
        };
        combo = {
          fade = true;
          shadow = true;
          opacity = 1.0;
          focus = true;
        };

        dialog = {
          fade = true;
          shadow = true;
          opacity = 1.0;
          focus = true;
        };
        utility = {
          fade = true;
          shadow = true;
          opacity = 1.0;
          focus = true;
        };
        toolbar = {
          fade = true;
          shadow = true;
          opacity = 1.0;
          focus = true;
        };
        splash = {
          fade = true;
          shadow = true;
          opacity = 1.0;
          focus = true;
        };

        tooltip = {
          fade = true;
          shadow = true;
          opacity = 0.9;
          focus = true;
        };

        notification = {
          fade = true;
          shadow = true;
          opacity = 0.9;
          focus = true;
        };

        # AwesomeWM Wibox
        dock = {
          clip-shadow-above = true;
          shadow = true;
          opacity = 0.9;
        };

        dnd = {
          fade = true;
          shadow = false;
          opacity = 0.8;
        };

        # unknown = {};
        # desktop = {};
        # normal = { fade = true; };
      };
    };
  };
}
