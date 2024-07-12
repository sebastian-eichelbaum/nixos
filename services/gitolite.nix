{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Gitolite
  #
  # A simple git repository server. Its config is stored in a git repo itself.
  #

  services.gitolite = {
    enable = true;

    # The initiallky authorized_keys entry for the git user. After setup,
    # gitolite manages the authorized_keys for us.
    adminPubkey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIz2weQ+ATNAbRmMazQrFOW2TdYQj4VlPr+3CuCNiMeb seb@worky";

    # Have a specific user for this
    user = "git";
    group = "git";
    description = "Gitolite user";

    # Run in this dir. The default is in /var/lib/gitolite.
    dataDir = "/home/git";
  };

  # The doc states: it is our own obligation to create the dataDir if it is not the default one.
  systemd.tmpfiles.rules =
    [ "d ${config.services.gitolite.dataDir} 0770 git git -" ];
}
