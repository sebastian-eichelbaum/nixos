{ config, pkgs, lib, ... }:

{
  # Nice daemon and command-line tool to configure the power states, fans & lights of Razer laptops.
  imports = [
    (builtins.getFlake
      "github:Razer-Linux/razer-laptop-control-no-dkms").nixosModules.default
  ];
  services.razer-laptop-control.enable = true;

  # Also checkout https://www.rzrctrl.com/ - to make this work, allow users to access the corresponding devices:
  #services.udev.extraRules = ''
  #  ## Allow tools that configure razer keyboard and power modes
  #  KERNEL=="hidraw*", ATTRS{idProduct}=="020f|0210|0224|0225|022d|022f|0232|0233|0234|0239|023a|023b|0240|0245|0246|024a|0252|0253|0255|0256|026a|026f|0270|0276|026d|027a|028a|028b|028c|0259|029f|029d|026e|", ATTRS{idVendor}=="1532", MODE="0666", TAG+="uaccess"
  #'';
}
