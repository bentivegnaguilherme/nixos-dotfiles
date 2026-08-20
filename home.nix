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
       ];
       file.".config/niri/config.kdl".source = ./niri-config.kdl;
     };

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
