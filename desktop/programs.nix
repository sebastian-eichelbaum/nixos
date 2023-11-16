{ config, lib, pkgs, ... }:

{

  #############################################################################
  # Apps
  #

  # Firefox by default, some options pre-set.
  programs.firefox = {
    enable = true;

    # Native hosts:
    nativeMessagingHosts.packages = with pkgs; [ passff-host tridactyl-native];

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
