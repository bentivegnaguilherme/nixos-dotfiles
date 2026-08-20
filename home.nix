  { config, pkgs, ... }:
 
  {
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
     };

    programs = {
      bash = {
        enable = true;
        shellAliases = {
          btw = "echo i use arch btw";
        };
      };
    };
  }  
