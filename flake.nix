{
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-23.11";
    };
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
    };
    commiepenguin = {
      url = "github:Dines97/nixos-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {self, ...} @ inputs:
    inputs.utils.lib.mkFlake {
      inherit self inputs;
      channelsConfig = {
        allowUnfree = true;
        allowBroken = false;
      };
      channels.nixpkgs = {
        overlaysBuilder = channels: [
          (final: prev: {
            unstable = channels.nixpkgs-unstable;
          })
        ];
      };

      hosts.bismarck = {
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          inputs.home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kirell = {...}: {
              imports = [
                ./home.nix
                # inputs.commiepenguin.hmModules.neovim
              ];
            };
          }
        ];
      };
    };
}
