# Shared configuration for every machine. Host-specific stuff (hardware,
# GPU drivers) lives in hosts/<hostname>/.
{ config, lib, pkgs, noctalia, hostname, ... }:

{
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Sao_Paulo";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics.enable = true;

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
    users.gui = import ../home.nix;
    extraSpecialArgs = { inherit noctalia; };
    backupFileExtension = "backup";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  fonts.packages = with pkgs; [ jetbrains-mono ];

  hardware.bluetooth.enable = true;

  programs.fish.enable = true; # required for users.users.gui.shell

  # Lets dynamically-linked prebuilt binaries run (mason tools like stylua).
  programs.nix-ld.enable = true;

  users.users.gui = {
    isNormalUser = true;
    shell = pkgs.fish; # login shell; kitty spawns this automatically
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
