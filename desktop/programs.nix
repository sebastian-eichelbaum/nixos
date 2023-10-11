{ config, lib, pkgs, ... }:

{

  #############################################################################
  # Apps
  #

  # Firefox by default, some options pre-set.
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.passff = true;
    nativeMessagingHosts.tridactyl = true;

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

    # Communication
    rocketchat-desktop
    slack
    discord
    thunderbird

    # Utils
    speedcrunch
    flameshot

    # Entertainment
    spotify
    vlc
  ];

}
