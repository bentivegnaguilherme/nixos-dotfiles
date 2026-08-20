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
        ];
        file.".config/niri/config.kdl".source = ./niri-config.kdl;
        file.".config/noctalia/config.toml".source = ./noctalia-config.toml;
        file.".config/fish/config.fish".source = ./fish-config.fish;
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
