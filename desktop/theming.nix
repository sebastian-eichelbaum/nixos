{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Fonts
  #

  fonts.packages = with pkgs; [
    # Commonly used fonts
    liberation_ttf
    dejavu_fonts
    ubuntu_font_family
    roboto
    noto-fonts

    # Fancy icon fonts. Used in Awesome.
    font-awesome
    font-awesome_5

    # Coding/Shell Fonts
    (nerdfonts.override { fonts = [ "Hack" ]; })
  ];

  #############################################################################
  # GTK Theming Support
  #

  environment.systemPackages = with pkgs; [
    # Icon Theme.
    papirus-icon-theme

    # An GTK3 Theme that re-uses the GTK4 libadwaita style for GTK3 apps.
    adw-gtk3

    # Tool to configure the colors of libadwaita/gtk4 apps.
    gradience

    # ATTENTION: All the nice GTK themes, like "Fluent" are not working
    #            properly. Forget about them. Use gradience to colorize
    #            the libadwaita/gtk4 themes.
  ];

  # NOTE: since Gnome 43, the gtk-theme and icon-theme setting in gsettings
  # is ignored for all libadwaita apps. Currently, GTK_THEME env variable
  # seems to work still.
  environment.sessionVariables = rec {
    # GTK Theme to use: make gtk3 use gtk4 theming.
    # NOTE: this also affects GTK4 apps.
    GTK_THEME = "adw-gtk3-dark";

    # Make Mozilla System Themes have a proper titlebar without additional
    # decorations.
    MOZ_GTK_TITLEBAR_DECORATION = "none";
  };

  # HOWTO set the icon themes?
  # In .config/gtk-4.0/settings.ini, add gtk-icon-theme-name = Papirus
  # -> A set of gtk2, 3, 4 configs via dotfiles

  #############################################################################
  # QT Theming Support
  #

  # Set the correct vars to make Qt apps look like adwaita.
  # NOTE: refer to the docs for valid values. You cannot simply use the desired
  # theme name. Using adwaita does NOT use the above re-colored theme
  # unfortunately.
  qt.enable = true;
  qt.style = "adwaita-dark"; # Most close match?!
  qt.platformTheme = "gnome";
}
