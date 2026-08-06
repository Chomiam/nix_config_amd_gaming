{
  config,
  pkgs,
  lib,
  ...
}:

{

  # Remplacez "votre_nom_d_utilisateur" par votre identifiant système
  home.username = "chomiam";
  home.homeDirectory = "/home/chomiam";

  # Configuration du Dock GNOME avec vos applications
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "io.github.kolunmi.Bazaar.desktop"
        "google-chrome.desktop"
        "discord.desktop"
        "steam.desktop"
        "net.lutris.Lutris.desktop"
        "com.heroicgameslauncher.hgl.desktop"
        "onlyoffice-desktopeditors.desktop"
        "thunderbird.desktop"
        "com.obsproject.Studio.desktop"
      ];
    };

    "org/gnome/mutter" = {
      # Option d'expérimentation Mutter pour débloquer la prise en charge du Tearing sous GNOME
      experimental-features = lib.hm.gvariant.mkArray "s" [
        "scale-monitor-framebuffer"
        "xwayland-native-scaling"
      ];
    };

    # Couleur d'accentuation GNOME (fermé correctement avec le ';')
    "org/gnome/desktop/interface" = {
      accent-color = "purple";
    };

    # Configuration de Dash to Dock (au premier niveau du dconf.settings)
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "LEFT";
      dock-fixed = true;
      extend-height = true;
      dash-max-icon-size = 48;
    };
  };

  # Theme fastfetch (ici on defini l'exemple 13 comme thème)
  xdg.configFile."fastfetch/config.jsonc".source =
    "${pkgs.fastfetch}/share/fastfetch/presets/examples/13.jsonc";

  home.sessionVariables = {
    # Variable d'environnement pour forcer l'autorisation du tearing dans Wayland / Gamescope
    "KWIN_DRM_USE_MODIFIER" = "0"; # Pour la compatibilité si besoin
    "MUTTER_DEBUG_FORCE_KMS_MODE" = "simple";
  };

  # Corrige l'avertissement sur le curseur dans Home Manager
  home.pointerCursor.enable = true;

  # Paquets utilisateur optionnels gérés par Home Manager
  home.packages = with pkgs; [
    # Vous pouvez ajouter d'autres outils ici si besoin
  ];

  # Active la gestion de Home Manager
  programs.home-manager.enable = true;

  # Exemple si vous utilisez un terminal ou éditeur en particulier :
  # kitty.enable = true;
  # vscode.enable = true;

  # Ne pas modifier cette valeur : elle indique la version initiale de Home Manager
  # utilisée pour des raisons de compatibilité ascendante.
  home.stateVersion = "26.05";
}
