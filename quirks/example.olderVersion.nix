{ config, pkgs, ... }:

# This is an example of how to override a package to use an older version.
# 1. Find the desired version at https://lazamar.co.uk/nix-versions/
# 2. Create the package set with the desired version
# 3. Install the package from that package set
let
  # See https://lazamar.co.uk/nix-versions/?channel=nixos-unstable&package=unityhub
  oldPkgs = import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "my-old-revision";
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "3e2cf88148e732abc1d259286123e06a9d8c964a";
  }) {

    config.allowUnfree = true;
  };
in {
  environment.systemPackages = with pkgs;
    [
      # Install
      oldPkgs.unityhub
    ];
}

