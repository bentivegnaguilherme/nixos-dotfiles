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

  # Greeter on the main monitor (ASUS VG27AQ5A); the Dell stays off until login.
  programs.noctalia-greeter.settings.output.name = "DP-2";
}
