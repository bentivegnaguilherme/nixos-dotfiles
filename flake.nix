  {
    inputs = {
      nixpkgs.url = "nixpkgs/nixos-26.05";
      home-manager = {
        url = "github:nix-community/home-manager/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      noctalia.url = "github:noctalia-dev/noctalia/cachix";
      noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    };

    nixConfig = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };

    outputs = { self, nixpkgs, home-manager, noctalia, noctalia-greeter, ... }: {
      nixosConfigurations.archlinux = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	specialArgs = { inherit noctalia; };
        modules = [
          ./configuration.nix
	  noctalia-greeter.nixosModules.default
          home-manager.nixosModules.home-manager
        ];        
      };
    };
  }    
