  {
    inputs = {
      nixpkgs.url = "nixpkgs/nixos-26.05";
      home-manager = {
        url = "github:nix-community/home-manager/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      noctalia.url = "github:noctalia-dev/noctalia/cachix";
    };

    nixConfig = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };

    outputs = { self, nixpkgs, home-manager, noctalia, ... }: {
      nixosConfigurations.archlinux = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.gui = import ./home.nix;
	      extraSpecialArgs = { inherit noctalia; };
              backupFileExtension = "backup";
            };
          }
        ];        
      };
    };
  }    
