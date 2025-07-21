# #############################################################################
# AI tools and UIs
#

{ config, lib, pkgs, ... }: {

  environment.systemPackages = with pkgs;
    [

      ###########################################################################
      # Standard tools
      #

      # Tabby is self-hosted, supports multiple models.
      #(pkgs.tabby.override {
      #  cudaSupport = true;
      #  acceleration = "cuda";
      #})
      # tabby-agent # required for the vim plugins

    ];

  # AI Tools: as the cuda integration requires this to be compiled all the time, I chose to use them via flakes+direnv.

  # A web-based frontend for several AI services, including ollama
  # services.open-webui = {
  #   enable = true;
  #
  #   # Make it available in the local network
  #   host = "0.0.0.0";
  #   port = 11111;
  #   openFirewall = true;
  #
  #   environment = {
  #     # Disable telemetry and tracking
  #     ANONYMIZED_TELEMETRY = "False";
  #     DO_NOT_TRACK = "True";
  #     SCARF_NO_ANALYTICS = "True";
  #
  #     # The local Ollama server
  #     OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
  #
  #     # Disable auth?
  #     WEBUI_AUTH = "False";
  #   };
  # };
  #
  # # Comfortable CLI and server to run local llms
  # services.ollama = {
  #   enable = true;
  #
  #   host = "127.0.0.1"; # Use 0.0.0.0 for local network access
  #   port = 11434;
  #
  #   # Force a certain acceleration? Using null uses cuda/rocm, depending on nixpkgs.config.cudaSupport/rocmSupport.
  #   # NOTE: cudaSupport is never set as it will cause a lot of packages to compile locally.
  #   acceleration = "cuda";
  # };
}
