{ config, lib, pkgs, ... }:

{
  #############################################################################
  # Allow users to access some USB devices
  #

  # Android fastboot/adb
  # SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="plugdev"

  # Nintendo Switch
  # SUBSYSTEM=="usb", ATTR{idVendor}=="057e", ATTR{idProduct}=="3000", MODE="0660", GROUP="users"

  # Adafruit Feather 32u4 Basic Proto
  #SUBSYSTEM=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="800c", MODE="0660", GROUP="users"
  # Adafruit Trinket Pro
  #SUBSYSTEM=="usb", ATTRS{idVendor}=="1781", ATTRS{idProduct}=="0c9f", MODE="0660", GROUP="users"
  # Arduino Micro
  #SUBSYSTEM=="tty", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="8037", MODE="0666", GROUP="users"
  # Arduino Micro Bootloader - Seperate ID
  #SUBSYSTEM=="tty", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0037", MODE="0666", GROUP="users"

  # Oculus Quest 2/3
  SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0660", GROUP="users"
}

