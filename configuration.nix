{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];
  
  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "archlinux";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Sao_Paulo";

  programs.niri.enable = true;
    
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  
  hardware.bluetooth.enable = true;

  users.users.gui = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  environment.systemPackages = with pkgs; [
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  zramSwap = {
    enable = true;
    memoryPercent = 25;  
    priority = 100;   
  };

  system.stateVersion = "26.05";

}

