{
  description = "Configuration NixOS avec Flakes, Flatpak, Home Manager et Chaotic-Nyx";

  inputs = {
    # Nixpkgs stable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Chaotic-Nyx
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Module Flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # Module Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Thèmes GRUB2
    grub2-themes.url = "github:vinceliuice/grub2-themes";

    # Module Stylix (Thématisation)
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./configuration.nix

          # Chaotic-Nyx Module
          inputs.chaotic.nixosModules.default

          # Flatpak
          inputs.nix-flatpak.nixosModules.nix-flatpak

          # Home Manager
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.chomiam = import ./home.nix;
            };
          }

          # GRUB2 Themes
          inputs.grub2-themes.nixosModules.default

          # Stylix
          inputs.stylix.nixosModules.stylix
        ];
      };
    };
}
