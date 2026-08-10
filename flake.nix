{
  description = "Configuration NixOS avec Flakes, Flatpak, Home Manager et Chaotic-Nyx";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    grub2-themes.url = "github:vinceliuice/grub2-themes";

    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yt-x = {
      url = "github:Benexl/yt-x";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      # Transmet l'argument 'inputs' à configuration.nix et aux modules système
      specialArgs = { inherit inputs; };

      modules = [
        { nixpkgs.hostPlatform = "x86_64-linux"; }
        ./configuration.nix
        inputs.chaotic.nixosModules.default
        inputs.nix-flatpak.nixosModules.nix-flatpak
        inputs.grub2-themes.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            sharedModules = [ inputs.catppuccin.homeModules.catppuccin ];
            users.chomiam = import ./home.nix;
          };
        }
      ];
    };
  };
}
