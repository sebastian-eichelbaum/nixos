{ config, pkgs, ... }:

{
  # In here, add packages that are known to be insecure but you need to allow anyway. This can sometimes be the case
  # when installing a pacakage that depends on an older version of a library with known vulnerabilities.

  nixpkgs.config.permittedInsecurePackages = [ "libxml2-2.13.8" ];
}
