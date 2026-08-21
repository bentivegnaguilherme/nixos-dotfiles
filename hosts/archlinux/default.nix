# Machine-specific configuration: NVIDIA GPU + this machine's hardware.
{ lib, pkgs, ... }:

let
  # Rise Mode Aura Ice AIO temp display, packaged from
  # github.com/Finallf/risemode (upstream install.sh is Debian-oriented).
  risemode = pkgs.stdenv.mkDerivation {
    pname = "risemode";
    version = "unstable-2026-04-06";
    src = pkgs.fetchFromGitHub {
      owner = "Finallf";
      repo = "risemode";
      rev = "79e8746170a109050b7cadfa6383c4b36f3c8f53";
      hash = "sha256-bE16a1540GpQTsX6HSpjmVlNSO61xu/Mrj3K+YXfO4U=";
    };
    dontBuild = true;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      runHook preInstall
      install -Dm755 risemode.sh $out/bin/risemode
      patchShebangs $out/bin/risemode
      wrapProgram $out/bin/risemode \
        --prefix PATH : ${lib.makeBinPath [ pkgs.lm_sensors pkgs.gnugrep pkgs.coreutils ]}
      runHook postInstall
    '';
  };
in

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
  # ~/.config/OpenRGB/autostart.orp via the GUI's Save Profile button.
  services.hardware.openrgb.enable = true;
  services.udev.packages = [ pkgs.openrgb ];
  boot.kernelModules = [ "i2c-dev" ];
  systemd.services.openrgb.serviceConfig.ExecStart = lib.mkForce
    "${pkgs.openrgb}/bin/openrgb --server --profile /home/gui/.config/OpenRGB/autostart.orp";

  # Show CPU temp on the pump display; runs as root (writes /dev/hidraw*).
  systemd.services.risemode = {
    description = "CPU temp on Rise Mode Aura Ice AIO display";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${risemode}/bin/risemode";
      Restart = "always";
      RestartSec = 5;
    };
  };
}
