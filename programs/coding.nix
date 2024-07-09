# #############################################################################
# Work related stuff
#

{ config, lib, pkgs, ... }:

{

  # Ensure that all runtimes are enabled. Neovim itself is enabled as system default
  # editor already.
  programs.neovim = {
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };

  environment.systemPackages = with pkgs; [

    ###########################################################################
    # Editors
    #

    # VS Code is working well with unity and has good C# support out of the box
    vscode

    ###########################################################################
    # Standard tools
    #

    git-lfs

    # NOTE: do not install any compiler here. Use devbox/devenv/shell.nix for
    # projects instead.

    # One exception though: the system gcc - although devbox/devenv should
    # provide these for projects, it helps to build wheels with pip for
    # example. This ensures the lib versions match.
    gcc
    gnumake
    gdb

    # Formatter. Very handy for most dev scenarios
    clang-tools_16
    nodePackages.prettier

    # Very nice for big directory comparisons
    meld
    gittyup

    ###########################################################################
    # Local coding environemnt basics:

    devbox

    # Devenv recommends cachix as everything is build from source.
    #(import (fetchTarball https://install.devenv.sh/latest)).default

    ###########################################################################
    # Development: Unity
    #

    # Some older unity editor versions need an old openssl version
    (pkgs.unityhub.override {
      extraLibs = pkgs:
        with pkgs; [
          # Without this, the vulkan libs will not be found -> no vulkan
          # renderer in unity (required for HDRP)
          vulkan-loader

          # Pre 2022.3 versions require this:
          # openssl_1_1

          # To ensure unity finds VS Code in its path
          vscode
        ];
    })

    # Dotnet SDK is required if VS Code C# extensions should be used
    dotnet-sdk_7

    ###########################################################################
    # Development: Cuda
    #

    # Contains the required tools too run CUDA stuff and nvcc.
    cudatoolkit
    # Random number generation
    cudaPackages.libcurand

  ];

  # Needed for Unity Editor pre 2022.3.1f1 - REMOVE as soon as possible.
  #nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1v" ];

}
