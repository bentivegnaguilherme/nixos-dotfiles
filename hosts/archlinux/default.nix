# Machine-specific configuration: NVIDIA GPU + this machine's hardware.
{ ... }:

{
  imports = [ ./hardware.nix ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
  };
}
