# #############################################################################
# AI tools and UIs
#

{ config, lib, pkgs, ... }: {

  environment.systemPackages = with pkgs;
    [

      ###########################################################################
      # Standard tools
      #

      ###########################################################################
      # AI TUI/UI
      #

      # Nice tool for interacting with AI chat models from the terminal
      aichat

    ];
}
