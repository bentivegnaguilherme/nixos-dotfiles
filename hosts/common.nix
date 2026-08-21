# Shared configuration for every machine. Host-specific stuff (hardware,
# GPU drivers) lives in hosts/<hostname>/.
{ config, lib, pkgs, noctalia, hostname, username, ... }:

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
        user.default = username;
      };
    };
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../home.nix;
    extraSpecialArgs = { inherit noctalia username; };
    backupFileExtension = "backup";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  fonts.packages = with pkgs; [ jetbrains-mono ];

  hardware.bluetooth.enable = true;

  programs.fish.enable = true; # required for users.users.${username}.shell

  # Lets dynamically-linked prebuilt binaries run (mason tools like stylua).
  programs.nix-ld.enable = true;

  # Allow Firefox userChrome.css (Noctalia color sync in home.nix).
  environment.etc."firefox/policies/policies.json".text = builtins.toJSON {
    policies = {
      Preferences = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = {
          Value = true;
          Status = "locked";
        };
      };
    };
  };

  users.users.${username} = {
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
