{ config, lib, pkgs, ... }:

{

  #############################################################################
  # XDG Mime and Default Apps
  #

  # This allows to configure the XDG Mime <-> App mapping.
  # I.e. - you want SVG to always open in Inkscape, define it here.
  xdg.mime = {
    enable = true;

    # Default mappings.
    # WARNING: some application desktop files are wierdly named. Check the contents
    # of the appropriate package for details
    defaultApplications = {
      "application/pdf" = "org.gnome.Evince.desktop";

      # Images:
      "image/" =
        [ "org.gnome.Loupe.desktop" "org.gnome.eog.desktop" "gimp.desktop" ];
      "image/svg+xml" = [
        "org.gnome.Loupe.desktop"
        "org.gnome.eog.desktop"
        "org.inkscape.Inkscape.desktop"
        "gimp.desktop"
      ];
      "image/png" =
        [ "org.gnome.Loupe.desktop" "org.gnome.eog.desktop" "gimp.desktop" ];
      "image/jpg" =
        [ "org.gnome.Loupe.desktop" "org.gnome.eog.desktop" "gimp.desktop" ];
      "image/jpeg" = [
        "org.gnome.Loupe.desktop"
        "org.gnome.eog.desktop"
        "gimp.desktop"
      ]; # different from jpg. Why?
      "image/webp" =
        [ "org.gnome.Loupe.desktop" "org.gnome.eog.desktop" "gimp.desktop" ];

      # Text
      "text/" = [ "nvim.desktop" "code.desktop" ];
      "text/plain" = [ "nvim.desktop" "code.desktop" ];
    };

    # Add other software explicitly:
    # addedAssociations
    # Remove these mappings explicitly:
    # removedAssociations
  };

  #############################################################################
  # Apps
  #

  # Firefox by default, some options pre-set.
  programs.firefox = {
    enable = true;

    # Native hosts:
    nativeMessagingHosts.packages = with pkgs; [ passff-host tridactyl-native ];

    # Note: this is not the dictionary list.
    languagePacks = [ "en-US" "de" ];

    # Do not overdo it. Most important stuff is synced with Firefox Sync anyway
    preferences = { "browser.tabs.closeWindowWithLastTab" = false; };
  };

  environment.systemPackages = with pkgs; [
    # Browsers
    google-chrome

    # Graphics+Office tools
    gimp
    inkscape
    libreoffice
    ocrmypdf
    pandoc

    # Communication - Most stuff works nicely with ferdium!
    # rocketchat-desktop
    # slack
    # discord
    ferdium
    thunderbird

    # Utils
    speedcrunch
    flameshot

    # Entertainment
    spotify
    vlc
  ];

}
