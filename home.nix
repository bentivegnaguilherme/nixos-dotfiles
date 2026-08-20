  { config, pkgs, ... }:
 
  {
     home = {
       username = "gui";
       homeDirectory = "/home/gui";
       stateVersion = "26.05";
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
