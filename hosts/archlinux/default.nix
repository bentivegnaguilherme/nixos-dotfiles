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

  # OpenRGB: udev rules + SDK server at boot, applying the profile saved as
  # ~/.config/OpenRGB/profiles/autostart.orp (create it once in the GUI).
  services.hardware.openrgb.enable = true;
  services.udev.packages = [ pkgs.openrgb ];
  boot.kernelModules = [ "i2c-dev" ];
  systemd.services.openrgb.serviceConfig.ExecStart = lib.mkForce
    "${pkgs.openrgb}/bin/openrgb --server --profile /home/gui/.config/OpenRGB/profiles/autostart.orp";
}
