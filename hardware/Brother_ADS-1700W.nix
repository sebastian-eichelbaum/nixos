{ options, config, lib, pkgs, ... }:

{
  #############################################################################
  # Brother ADS-1700W Scanner
  #

  # This devices uses some old Kex/Mac/HostKey Algorithms.

  services.openssh = {
    # To make the Brother Scanner work
    settings = {
      KexAlgorithms = (options.services.openssh.settings.type.getSubOptions
        [ ]).KexAlgorithms.default ++ [ "diffie-hellman-group14-sha1" ];
      Macs =
        (options.services.openssh.settings.type.getSubOptions [ ]).Macs.default
        ++ [ "hmac-sha1" ];
    };

    # Add some old key algorithms to make some older hardware work
    # Macs +hmac-sha1
    # KexAlgorithms +diffie-hellman-group14-sha1
    extraConfig = ''
      HostKeyAlgorithms +ssh-rsa
      PubkeyAcceptedAlgorithms +ssh-rsa
    '';
  };
}

