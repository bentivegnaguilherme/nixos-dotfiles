# Machine-specific configuration: 2013 laptop (Intel HD 4000 only).
# Disable the GT 735M in BIOS — the legacy nvidia-390 driver doesn't
# support modern Wayland, and the Intel GPU handles everything fine.
{ lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  # Intel GPU — no nvidia block, no openrgb, no risemode.
  hardware.graphics.enable = true;

  # Greeter on the laptop's internal display.
  programs.noctalia-greeter.settings.output.name = "eDP-1";
}
