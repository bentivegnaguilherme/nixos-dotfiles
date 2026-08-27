# Placeholder — replace with output of `nixos-generate-config --show-hardware-config`
# after booting the NixOS installer on the laptop.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Typical 2013 Intel laptop modules. Adjust after nixos-generate-config.
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # FIXME: replace UUIDs with real values from `blkid` on the laptop.
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/REPLACE-ME";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/REPLACE-ME";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
