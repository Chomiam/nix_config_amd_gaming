{
  config,
  pkgs,
  lib,
  ...
}:

{
  # 1. Déclaration de l'option de compatibilité kmscon
  options.services.kmscon.config = lib.mkOption {
    type = lib.types.anything;
    default = { };
    description = "Dummy option pour Stylix";
  };

  # 2. Section de configuration explicite
  config = {
    stylix = {
      enable = true;

      # Cibles d'intégration (targets)
      targets.grub.enable = false;
      targets.qt.platform = lib.mkForce "qtct";
      targets.gtk.enable = true;
      targets.gnome.enable = true;

      # Image de fond d'écran
      # image = pkgs.fetchurl {
      #   url = "https://raw.githubusercontent.com/dracula/wallpaper/master/first-collection/nixos.png";
      #   sha256 = "0q9wd4g7fyzy38dkmknkz2p58xxh03yk916zdyqhlj0qagxnr444";
      # };

      # Schéma de couleurs Dracula
      base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
      polarity = "dark";

      # Curseur
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };

      # Icônes
      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };

      # Polices
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        sansSerif = {
          package = pkgs.ubuntu-classic;
          name = "Ubuntu";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        sizes = {
          applications = 11;
          terminal = 11;
          desktop = 11;
          popups = 11;
        };
      };
    };
  };
}
