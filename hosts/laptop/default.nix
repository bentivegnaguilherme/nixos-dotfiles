# Machine-specific configuration: 2013 laptop (Intel HD 4000 only).
# Disable the GT 735M in BIOS — the legacy nvidia-390 driver doesn't
# support modern Wayland, and the Intel GPU handles everything fine.
{ lib, pkgs, config, ... }:

{
  imports = [ ./hardware.nix ];

  # Allow the legacy broadcom-sta driver (needed for BCM43142 WiFi).
  nixpkgs.config.permittedInsecurePackages = [ "broadcom-sta-6.30.223.271-59-6.18.45" ];

  # Intel GPU — no nvidia block, no openrgb, no risemode.
  hardware.graphics.enable = true;

  # Broadcom BCM43142 WiFi — needs proprietary driver.
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  # Greeter on the laptop's internal display.
  programs.noctalia-greeter.settings.output.name = "eDP-1";
}
