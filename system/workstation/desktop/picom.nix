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

      #########################################################################
      # {{{ General
      #

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

      # }}}

      #########################################################################
      # {{{ Fading
      #

      # A fast fade-in/out
      fading = true;
      fade-in-step = 0.133;
      fade-out-step = 0.133;
      fade-delta = 10;

      # Do not fade on window open/close.
      no-fading-openclose = false;

      # }}}

      #########################################################################
      # {{{ Shadows
      #

      # Centered shadow
      shadow = true;
      shadow-offset-x = -50;
      shadow-offset-y = -50;
      shadow-opacity = 0.66;
      shadow-radius = 50;

      # }}}

      #########################################################################
      # {{{ Transparency
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

      # }}}

      #########################################################################
      # {{{ Blur
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

      # }}}

      #########################################################################
      # {{{ Animations
      #
      # Refer to https://picom.app/#_animations for details

      # Disabled. Looks nice but is annoying during work.
      # animations = [
      #   {
      #     triggers = [ "show" ];
      #     preset = "appear";
      #     scale = "0.5";
      #   }
      #   {
      #     triggers = [ "hide" ];
      #     preset = "disappear";
      #     scale = "0.5";
      #   }
      #   {
      #     triggers = [ "geometry" ];
      #     preset = "geometry-change";
      #   }
      # ];

      # }}}

      #########################################################################
      # {{{ Window type specific overrides
      #

      # See: https://picom.app/#_window_rules

      rules = [

        # Disable fading for normal windows except Rofi
        # This still fades menus, drop downs, ...
        {
          match = "window_type = 'normal' && class_g != 'Rofi'";
          fade = false;
        }

        # Menus need some re-styling.
        {
          match =
            "window_type *= 'menu' || window_type = 'dropdown_menu' || window_type = 'popup_menu' || window_type ='combo'";

          # Those GTK menus use a blurred frame that looks strange. Disable blur.
          blur-background = false;

          # Enable full shadow to have shadows on menus? The shadows looks huge on GTK menus.
          shadow = false;
          full-shadow = false;

          # Menus should be a bit transparent
          opacity = 0.95;
        }

        # Firefox has the same problem with those tab preview tooltips
        {
          match = "class_g = 'firefox'";
          shadow = true;
          full-shadow = true;
          blur-background = false;
        }

        # Window-manager dock
        {
          match = "window_type = 'dock'";
          shadow = true;
          opacity = 0.9;
          clip-shadow-above = true;
        }
      ];

      #}}}
    };
  };
}
