# Machine-specific configuration: NVIDIA GPU + this machine's hardware.
{ lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
  };

  # Greeter on the main monitor (ASUS VG27AQ5A); the Dell stays off until login.
  programs.noctalia-greeter.settings.output.name = "DP-2";

  # NOTE: this machine's RGB (openrgb) and AIO temp display (risemode)
  # services live only on the `archlinux` branch — they are hardware-
  # specific and don't belong in the universal config.
}
