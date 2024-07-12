{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Gitolite
  #
  # A simple git repository server. Its config is stored in a git repo itself.
  #
  # git clone git@HOSTNAME:gitolite-admin

  services.gitolite = {
    enable = true;

    # The initiallky authorized_keys entry for the git user. After setup,
    # gitolite manages the authorized_keys for us.
    adminPubkey = builtins.elemAt config.SysConfig.authorizedKeys 0;

    # Have a specific user for this
    user = "git";
    group = "git";
    description = "Gitolite user";

    # Run in this dir. The default is in /var/lib/gitolite.
    dataDir = "/home/git";
  };

  # The doc states: it is our own obligation to create the dataDir if it is not the default one.
  systemd.tmpfiles.rules = [
    # ATTENTION: ssh does not like group writeable home dirs!
    "d ${config.services.gitolite.dataDir} 0750 git git -"
  ];
}
