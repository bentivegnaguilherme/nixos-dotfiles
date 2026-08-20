{ config, lib, pkgs, noctalia, ... }:

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

  programs = {
    niri.enable = true;
    noctalia-greeter = {
      enable = true;
      settings = {
        session.default = "Niri";
        user.default = "gui";
      };
    };
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.gui = import ./home.nix;
    extraSpecialArgs = { inherit noctalia; };
    backupFileExtension = "backup";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  
  fonts.packages = with pkgs; [ jetbrains-mono ];

  hardware.bluetooth.enable = true;

  users.users.gui = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  environment.systemPackages = with pkgs; [];
  environment.pathsToLink = [ "/share/wayland-sessions" ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;  
    priority = 100;   
  };

  system.stateVersion = "26.05";

}

