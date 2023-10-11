{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Development: Unity
  #

  environment.systemPackages = with pkgs; [

    # Some older unity editor versions need an old openssl version
    (pkgs.unityhub.override {
      extraLibs = pkgs:
        with pkgs;
        [
          # Without this, the vulkan libs will not be found -> no vulkan
          # renderer in unity (required for HDRP)
          vulkan-loader

          # Pre 2022.3 versions require this:
          # openssl_1_1
        ];
    })

    # VS Code is working well with unity.
    vscode

    # Nice formatting of C# code
    clang-tools_16

    # Dotnet SDK is required if VS Code C# extensions should be used
    dotnet-sdk_7
  ];

  # Needed for Unity Editor pre 2022.3.1f1 - REMOVE as soon as possible.
  #nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1v" ];

  # As with a lot of proprietary shit, explicitly list the library paths
  # using nix-ld
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ vulkan-loader ];
  };
}
