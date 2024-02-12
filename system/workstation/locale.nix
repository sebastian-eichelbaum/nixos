{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Locale Setup
  #

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n = {
    # Use C system-wide - this is like en_US but with 24h format
    defaultLocale = "en_US.UTF-8";
    # Nixos picks up the locales from defaultLocale and extraLocaleSettings and
    # builds support for them. It is NOT needed to add them here.
    #supportedLocales = [ "C.UTF-8" "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" ];

    # Fine-tune some properties:
    extraLocaleSettings = {
      #LC_CTYPE="en_US.UTF-8";
      #LC_NUMERIC="de_DE.UTF-8";
      LC_TIME = "en_GB.UTF-8"; # For 24h format
      #LC_COLLATE="en_US.UTF-8";
      #LC_MONETARY = "de_DE.UTF-8";
      #LC_MESSAGES="en_US.UTF-8";
      #LC_PAPER = "de_DE.UTF-8";
      #LC_NAME = "de_DE.UTF-8";
      #LC_ADDRESS = "de_DE.UTF-8";
      #LC_TELEPHONE = "de_DE.UTF-8";
      #LC_MEASUREMENT = "de_DE.UTF-8";
      #LC_IDENTIFICATION = "de_DE.UTF-8";
    };
  };
}
