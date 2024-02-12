{ config, lib, pkgs, ... }:

{
  # ATTENTION: this defines some basic system services.
  # DO NOT: no user specific services!

  #############################################################################
  # SSH
  #

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.openssh = {
    enable = true;

    # Definitely needed
    allowSFTP = true;

    # Disallow password login.
    settings.PasswordAuthentication = false;

    # NOTE: To modify Kex/Cipher/HostKey algorithms, check the quirks/Brother
    # file. Avoid fiddling in here. The defaults are SAFE defaults.
  };

  # Windows file sharing
  # Don't forget to set a password:  $ smbpasswd -a <user>
  #samba = {
  #  enable = true;
  #  shares = {
  #    share = {
  #      "path" = "/home/${user}";
  #      "guest ok" = "yes";
  #      "read only" = "no";
  #    };
  #  };
  #  openFirewall = true;
  #};

  #############################################################################
  # Others
  #

  # Locate service
  services.locate = {
    enable = true;
    package = pkgs.mlocate;
    # Default is during the night and will never trigger on a desktop that is off.
    interval = "12:00";
    localuser = null; # required by mlocate
  };

  # Tailscale VPN
  services.tailscale.enable = true;

  # Logrotate - needed?
  #services.logrotate.enable =true;
}
