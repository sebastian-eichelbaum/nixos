{ config, pkgs, ... }:

{

  #############################################################################
  # Some temporary fixes to make NixOS build properly
  #

  # When enabled, glaze/termbench do not compile
  environment.enableAllTerminfo = false;
}
