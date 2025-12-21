{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Printing and CUPS
  #

  services.printing = {
    enable = true;

    # Enable the CUPS PDF printer backend
    cups-pdf.enable = true;
  };

  # Enable Avahi for network printer discovery
  services.avahi = {
    enable = true;

    nssmdns4 = true;
    nssmdns6 = true;
  };
}
