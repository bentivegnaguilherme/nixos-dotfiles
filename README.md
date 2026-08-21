# nixos-dotfiles

Declarative NixOS configuration for all my machines: **niri** compositor + **Noctalia** desktop shell, fish, kitty, LazyVim, and everything themed to follow the wallpaper.

## Stack

| Layer      | Tool                                              |
|------------|---------------------------------------------------|
| OS         | NixOS 26.05 (flakes + home-manager)               |
| Compositor | [niri](https://github.com/YaLTeR/niri)            |
| Shell/UI   | [Noctalia](https://github.com/noctalia-dev/noctalia) (launcher, lock, clipboard, settings, greeter) |
| Terminal   | kitty                                             |
| Shell      | fish + starship                                   |
| Editor     | Neovim (LazyVim)                                  |
| Browser    | Firefox                                           |

## Machines

| Host        | GPU    | Notes                          |
|-------------|--------|--------------------------------|
| `archlinux` | NVIDIA | 2560x1440@200Hz main + 1080p side |

## New machine setup

The flake is multi-host: shared config lives in [`hosts/common.nix`](hosts/common.nix), each machine gets its own directory with its hardware file.

On the new machine, after installing a minimal NixOS (create your user during install — default expected username is `gui`):

```bash
# 1. Generate this machine's hardware file
sudo nixos-generate-config --dir /tmp/hw

# 2. Clone the dotfiles
git clone https://github.com/bentivegnaguilherme/nixos-dotfiles ~/nixos-dotfiles

# 3. Drop in the generated hardware config
mkdir -p ~/nixos-dotfiles/hosts/<name>
cp /tmp/hw/hardware-configuration.nix ~/nixos-dotfiles/hosts/<name>/hardware.nix

# 4. Create hosts/<name>/default.nix — copy hosts/archlinux/default.nix and
#    adjust the GPU section (delete the NVIDIA block entirely on AMD/Intel)

# 5. Register the host in flake.nix:
#      <name> = mkHost { hostname = "<name>"; };
#    (add `username = "<user>";` if the login differs from "gui")

# 6. Build and reboot
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#<name>
reboot
```

You'll land in the Noctalia greeter → Niri session, fully configured.

## Daily commands

```bash
# Apply config changes
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#archlinux

# Update flake inputs (nixpkgs, home-manager, noctalia...)
nix flake update ~/nixos-dotfiles

# Broke something? Roll back instantly
sudo nixos-rebuild switch --rollback
# ...or pick an older generation from the boot menu
```

Garbage collection runs weekly automatically (keeps 14 days).

## Repo layout

```
flake.nix              host list (mkHost) + inputs
hosts/
  common.nix           shared system config: niri, greeter, pipewire,
                       bluetooth (+ A2DP fix), fish, nix-ld, zram
  archlinux/
    default.nix        GPU drivers (NVIDIA)
    hardware.nix       disk UUIDs / partitions (machine-specific!)
home.nix               user packages + declarative app configs
niri-config.kdl        keybinds, layout, window rules
kitty.conf             terminal (Noctalia appends its theme include)
fish-config.fish       greeting off + starship
nvim/                  LazyVim starter + custom plugins/colors
noctalia-config.toml   canonical Noctalia settings
```

## Keybinds

Press `Mod+Shift+/` anytime for the built-in overlay. Highlights:

| Keys | Action |
|------|--------|
| `Mod+E` / `Mod+T` / `Mod+B` | terminal / files / browser |
| `Mod+Space` / `Mod+D` | Noctalia launcher / fuzzel |
| `Mod+S` / `Mod+Y` | settings / wallpaper picker |
| `Mod+V` | clipboard history |
| `Mod+Alt+L` | lock screen |
| `Mod+hjkl` | focus window/column (arrows work too) |
| `Mod+Shift+hjkl` | move window/column |
| `Mod+Ctrl+hjkl` | focus monitor |
| `Mod+Ctrl+Shift+hjkl` | send window to monitor |
| `Mod+U/I`, `Mod+1..9` | switch workspace |
| `Mod+Shift+U/I`, `Mod+Shift+1..9` | move window to workspace |
| `Mod+R` / `Mod+Shift+R` | cycle preset widths / heights |
| `Mod+F` / `Mod+M` | maximize column / true fullscreen |
| `Mod+Shift+T` / `Mod+Shift+V` | float window / focus floating |
| `Mod+O` / `Mod+Tab` | overview |
| `Alt+Tab` | recent-windows switcher |
| `[` / `]` with Mod | consume/expel windows between columns |
| `Print` (`Ctrl+`/`Alt+`) | screenshot (screen/window) |

## Theming

Everything follows the wallpaper via Noctalia (`Mod+Y`): GTK apps, kitty, Qt, starship, and niri accent colors regenerate automatically. Neovim reads kitty's theme file at startup, so it follows too. In Firefox pick **System Theme — Auto** to join the party.

## Gotchas

- The last line of `niri-config.kdl` includes `~/.config/niri/noctalia.kdl` — don't remove it, that's the theme bridge.
- `hardware.nix` files are per-machine; never copy one between machines.
- Mason-installed tools run thanks to `programs.nix-ld`; prefer adding tools via Nix when possible.
