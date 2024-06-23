# #############################################################################
# Host/Hardware Setup
#
# Hardware: Razer Blade Advanced 15, Late 2020

{ config, lib, pkgs, ... }:

{
  # The system "name" aka hostname
  networking.hostName = config.SysConfig.hostName;

  #############################################################################
  # Filesystem Setup
  #

  # NOTE: if those FS are on crypted disks, ensure they are listed in
  # boot.initrd.luks below.

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";

    # No fsck
    noCheck = false;

    # Mount options
    options = [
      # Avoid a lot of meta data IO
      "noatime"
      # enable TRIM
      "discard"
    ];
  };

  fileSystems."/home" = {
    #device = "/dev/disk/by-label/home";
    device = "/dev/mapper/crypthome";
    fsType = "ext4";

    # No fsck
    noCheck = false;

    # Mount options
    options = [
      # Avoid a lot of meta data IO
      "noatime"
      # enable TRIM
      "discard"
    ];
  };

  # UEFI ESP Partition as Boot partition. The default on NixOS.
  #
  # -> Use a seperate boot. Remember to set efiSysMountPoint in the bootloader
  # config.
  # fileSystems."/boot/efi" = {
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  # Swap
  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;
  }];

  # Enable periodic TRIM on these? Its an nvme ssd that supports it. Check
  # "lsblk --discard" to validate.
  #
  # Keep in mind: enabling periodic and continuous TRIM (using discard options
  # in fstab and crypttab/initrd luks) at the same time does not make sense.
  # Well, technically. If you forget some "hidden" discard somewhere in the
  # config, it is easy to miss a disk. And it does not cost you anything,
  # especially since it is run every week or so. Just enable it.
  services.fstrim.enable = true;

  #############################################################################
  # Crypto Setup
  #

  # Only root is needed for booting. To avoid unlocking home in initrd, it is
  # Listed in crypttab and uses a keyfile to unlock:
  # Create key:
  #   sudo dd if=/dev/random of=/root/crypthome.disk.key bs=4096 count=1
  # Set as Key:
  #   sudo cryptsetup luksAddKey /dev/nvme0n1p3 disk.key --iter-time 250
  #
  # NOTE: the options are to optimize for SSD. discard=allow_discards
  environment.etc."crypttab".text = ''
    # <target name>	<source device>		<key file>	<options>
    crypthome /dev/disk/by-uuid/1adf805f-b691-41af-ad68-e12c5d98ebe5 /root/crypthome.disk.key discard,no-read-workqueue,no-write-workqueue
  '';

  #############################################################################
  # Kernel and initrd Setup
  #

  boot = {
    # Kernel parameters
    kernelParams = [
      "i915.fastboot=1"
      "button.lid_init_state=open"

      # This makes some games perform better. But it is hard to find information on
      # what this actually does and how it affects other processes/the system
      # "split_lock_detect=off"
    ];

    # Initial ramdisk setup
    initrd = {
      # Always loaded from initrd
      kernelModules = [ "i915" ];

      # Modules that should be available in the initial ramdisk
      availableKernelModules = [
        # Connectivity
        "thunderbolt"
        "xhci_pci"

        # USB HID. To allow USB Keyboards in stage 1 (i.e. LUKS passwords)
        "usbhid"

        # USB Storage. Required if USB Keys should be used for LUKS unlock
        "usbcore"
        "usb_storage"
        "uas"

        # Storage
        "nvme"
        "sd_mod"

        # Crypt hardware support
        "aesni_intel"
        "crypto_simd"
        "cryptd"
      ];

      luks.devices = {
        "cryptroot" = {
          device = "/dev/disk/by-uuid/2bb00ea3-64e0-42dd-a168-18183a673e5a";

          # Supposed to help with ssd
          bypassWorkqueues = true;
          # Enable trim support
          allowDiscards = true;

          # Decrypt using a key file on a USB stick.
          # Create the key (or use the same) as shown above. Write to a stick:
          #   sudo dd if=disk.key of=/dev/sdc
          keyFileSize = 4096;
          keyFile = "/dev/disk/by-id/usb-Intenso_Micro_Line_23042277610577-0:0";
          keyFileTimeout = 5; # Still allow PW prompt
        };
      };
    };

    # Load these during the second boot stage
    kernelModules = [ ];

    # A list of packages containing additional, required kernel modules
    extraModulePackages = [ ];

    # Blacklist some modules.
    # WARNING: unlike many recommendations online, it is not recommended to
    #          disable uvcvideo or other drivers because they enable power
    #          management! Example: disable uvcvideo and the cam will not power
    #          down.
    blacklistedKernelModules = [ ];
  };

  #############################################################################
  # Hardware specifics
  #

  hardware.cpu.intel.updateMicrocode = true;
  hardware.cpu.amd.updateMicrocode = false;

  # use intel+nvidia vaapi. NOTE:
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    nvidia-vaapi-driver
  ];

  # Use intel va driver by default.
  environment.variables = { LIBVA_DRIVER_NAME = lib.mkDefault "iHD"; };

  #############################################################################
  # Power Configuration
  #

  powerManagement.enable = true;

  # The kernel sets this to max_performance by default. This machine has two SSD,
  # so setting a more power saving setting can save a few watts!
  powerManagement.scsiLinkPolicy = "med_power_with_dipm";

  # Makes better use of eficiency cores on newer intel machines
  services.thermald.enable = true;
  # services.thermald.configFile = "";

  # Enable Wifi PowerSave mode. Good idea?
  # networking.networkmanager.wifi.powersave = true;

  # Be warned. Enabling this activates a lot of power saving features but can
  # also mess up laptop keybords and mouse. This config uses udev rules to be
  # more specific.
  # powerManagement.powertop.enable = true;

  # P-States magic makes this superfluous.
  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  boot = {
    /* # i915 Module options:
       Used in debian: options i915 enable_guc=2 enable_psr=0 enable_fbc=0 fastboot=1

       # psr (Panel Self Refresh) can cause the screen go black for a second
       # enable_psr=0
       # fbc (compressed frame buffer) can cause the screen go black for a second
       # enable_fbc=0

       # GVT (virtual gpu) - incompativble with guc
       # enable_gvt=1
    */
    # Check the current parameters of a module:
    #   sudo grep -H '' /sys/module/i915/parameters/*
    #  or:
    #   nix-shell -p sysfsutils --run "sudo systool -vm i915"
    # List parameters with description:
    #   modinfo -p i915

    # NEVER: pcie_aspm=force - can cause system freezes
    #kernelParams = [ "pcie_aspm.policy=powersave" ];

    # Some module options
    extraModprobeConfig = ''
      options snd_hda_intel power_save=1

      options iwlwifi power_save=1 power_level=3 uapsd_disable=0
      options iwlmvm power_scheme=2
    '';

    # Some kernel options
    kernel.sysctl = {
      # Power optimizations:
      "kernel.nmi_watchdog" = 0;

      # How long to wait until dirty pages are written to disk.
      # a.k.a.: the amount of work you are willing to loose on power loss.
      # This value is assumed to be "good" by powertop ...
      "vm.dirty_writeback_centisecs" = 1500;

      # Does not make much sense for fast NVMe SSDs
      # "vm.laptop_mode" = 5;

      # Avoid Swap where possible.
      "vm.swappiness" = 1;
    };
  };

  /* ASPM
     cat /sys/module/pcie_aspm/parameters/policy
     echo powersave > /sys/module/pcie_aspm/parameters/policy
  */

  /* CPU Performance preference
     cat /sys/devices/system/cpu/cpufreq/policy?/energy_performance_available_preferences
     echo "performance" > /sys/devices/system/cpu/cpufreq/policy?/energy_performance_preference
  */

  # Some specific power save rules as well as blacklisting
  services.udev.extraRules = ''
    ## Blacklist autosuspend for some USB devices.

    ## The integrated keyboard. Use lsusb to get the ID for the Razer device.
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="029f", ATTR{power/autosuspend_delay_ms}="-1"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="029f", ATTR{power/control}="on"

    ## ALPM (Active Link Power Management) for SATA. The Card Reader. SATA SSD are also supported.
    ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="med_power_with_dipm"

    ## PCI PM

    # blacklist for pci runtime power management for these devices:
    # SUBSYSTEM=="pci", ATTR{vendor}=="0x1234", ATTR{device}=="0x1234", ATTR{power/control}="on", GOTO="pci_pm_end"

    # Enable runtim PM for all other devices
    SUBSYSTEM=="pci", ATTR{power/control}="auto"
    LABEL="pci_pm_end"

  '';

  #############################################################################
  # Other Host Configuration Modules
  #

  imports = [
    # This machine uses nvidia prime
    ../hardware/nvidia-prime.nix
    # Use Logitech input devices
    ../hardware/logitech-hid.nix
    # Use the Brother scanner
    ../hardware/Brother_ADS-1700W.nix
    # The Razer laptop controls. Allows to setup power states/light/...
    ../hardware/razer-laptop.nix
  ];

  # Apply the correct color profile (icm,icc) for this device
  services.xserver.displayManager.sessionCommands = ''
    # load if present
    profile=$HOME/.colorprofiles/RazerBlade16_2023/Blade16.icm
    if [ -f $profile ]; then
      xcalib -output eDP-0 $profile
    fi
  '';
}
