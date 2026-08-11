{
  description = "Configuration NixOS avec Flakes, Flatpak, Home Manager, Plasma Manager et Chaotic-Nyx";

  # ===========================================================================
  # 📦 INPUTS (SOURCES DE T'S PAQUETS ET MODULES)
  # ===========================================================================
  inputs = {
    # Nixpkgs branche stable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Dépôts tiers et modules système
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    grub2-themes.url = "github:vinceliuice/grub2-themes";

    # Thème Catppuccin
    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager (Gestion de l'environnement utilisateur)
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 📌 Plasma Manager (Configuration déclarative pour KDE Plasma)
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Outil Youtube yt-x
    yt-x = {
      url = "github:Benexl/yt-x";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ===========================================================================
  # ⚙️ OUTPUTS (ASSEMBLAGE DE LA CONFIGURATION NIXOS)
  # ===========================================================================
  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      # Transmet l'argument 'inputs' à configuration.nix et aux modules système
      specialArgs = { inherit inputs; };

      modules = [
        # Architecture système
        { nixpkgs.hostPlatform = "x86_64-linux"; }

        # Fichier de configuration principal du système
        ./configuration.nix

        # Insertion des modules système
        inputs.chaotic.nixosModules.default
        inputs.nix-flatpak.nixosModules.nix-flatpak
        inputs.grub2-themes.nixosModules.default
        inputs.home-manager.nixosModules.home-manager

        # Configuration spécifique de Home Manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };

        # 🛠️ Modules partagés pour tous les utilisateurs Home Manager
          sharedModules = [
              inputs.catppuccin.homeModules.catppuccin
              inputs.plasma-manager.homeModules.plasma-manager # Fix : homeModules et plasma-manager
            ];

            # Import du profil utilisateur
            users.chomiam = import ./home.nix;
          };
        }
      ];
    };
  };
}
