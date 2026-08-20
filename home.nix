  { config, pkgs, noctalia, ... }:
 
  {
     imports = [ noctalia.homeModules.default ];

     home = {
       username = "gui";
       homeDirectory = "/home/gui";
       stateVersion = "26.05";
packages = with pkgs; [
          kitty
          fish
          firefox
          tree
          neovim
          git
          opencode
          pulseaudio
          starship
          wl-clipboard # nvim system clipboard (wl-copy/wl-paste)
          lazygit # <leader>gg in LazyVim
          ripgrep # telescope live-grep
          fd # telescope file finding
          gcc # tree-sitter parser + avante build
          gnumake # avante build step
          bibata-cursors # Bibata-Modern-Classic (black) cursor theme
          nautilus # file manager
          gvfs # trash, network, device mounting for nautilus
        ];

        sessionVariables = {
          XCURSOR_THEME = "Bibata-Modern-Classic";
          XCURSOR_SIZE = "24";
        };
        file.".config/niri/config.kdl".source = ./niri-config.kdl;
        file.".config/noctalia/config.toml".source = ./noctalia-config.toml;
        file.".config/fish/config.fish".source = ./fish-config.fish;
        file.".config/kitty/kitty.conf".source = ./kitty.conf;
        file.".config/nvim".source = ./nvim;
      };

    xdg.configFile."wireplumber/wireplumber.conf.d/50-bluez-a2dp.conf".text = ''
      monitor.bluez.rules = [
        {
          matches = [
            {
              device.name = "~bluez_card.F4_4E_FC_EB_62_87$"
            }
          ]
          actions = {
            update-props = {
              bluez5.profiles = [ a2dp_sink ]
            }
          }
        }
      ]
    '';

    programs = {
      bash = {
        enable = true;
        shellAliases = {
          btw = "echo i use arch btw";
        };
      };
      noctalia = {
        enable = true;
      };
    };
  }  
