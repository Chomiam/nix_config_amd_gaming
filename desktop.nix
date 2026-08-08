{
  config,
  pkgs,
  lib,
  ...
}:

{
  # =======================================================================
  # 🖥️ GESTIONNAIRE D'ENVIRONNEMENTS DE BUREAU
  # Commentez / Décommentez les blocs pour changer d'environnement.
  # Les paramètres système ET utilisateur (Home Manager) sont unifiés ici.
  # =======================================================================

  # -----------------------------------------------------------------------
  # 🟢 1. GNOME (ACTIF)
  # -----------------------------------------------------------------------

  # #Active le serveur graphique X11 (Requis comme socle par DisplayManager/GNOME)
  # services.xserver.enable = true;

  # # Active le gestionnaire de connexion graphique GDM (GNOME Display Manager)
  # services.displayManager.gdm.enable = true;

  # # Active l'environnement de bureau GNOME Shell
  # services.desktopManager.gnome.enable = true;

  # # Applique automatiquement le thème global Stylix à l'interface GNOME
  # stylix.targets.gnome.enable = true;

  # # Liste des applications GNOME par défaut à ne pas installer sur le système
  # environment.gnome.excludePackages = with pkgs; [
  #   totem # Lecteur vidéo GNOME par défaut (GNOME Videos)
  #   gnome-maps # Application de cartographie
  #   yelp # Centre d'aide et documentation GNOME
  #   gnome-tour # Application de visite guidée au premier démarrage
  #   epiphany # Navigateur web GNOME (Web)
  # ];

  # # Outils et extensions GNOME installés pour l'utilisateur "chomiam"
  # users.users."chomiam".packages = with pkgs; [
  #   gnome-tweaks # Outil d'ajustements avancés pour GNOME (Ajustements)
  #   gnome-extension-manager # Application native pour chercher, installer et gérer les extensions
  #   gnomeExtensions.dash-to-dock # Extension : Transforme le dash GNOME en dock permanent
  #   gnomeExtensions.blur-my-shell # Extension : Ajoute un effet de flou esthétique (blur) sur le shell/panel
  #   gnomeExtensions.appindicator # Extension : Prise en charge des icônes de la zone de notification (systray)
  #   gnomeExtensions.vitals # Extension : Affichage des métriques matérielles (températures, CPU, RAM) dans la barre du haut
  #   gnomeExtensions.clipboard-indicator # Extension : Gestionnaire d'historique du presse-papier
  #   gnomeExtensions.arcmenu # Extension : Menu démarrer alternatif hautement personnalisable
  # ];

  # # Activation système des extensions GNOME via dconf
  # programs.dconf.profiles.user.databases = [
  #   {
  #     settings = {
  #       "org/gnome/shell" = {
  #         # Liste des UUIDs d'extensions actives par défaut pour la session
  #         enabled-extensions = [
  #           "blur-my-shell@aunetx"
  #           "appindicatorsupport@rgcjonas.gmail.com"
  #           "Vitals@CoreCoding.com"
  #           "clipboard-indicator@tudmotu.com"
  #           "arcmenu@arcmenu.com"
  #         ];
  #       };
  #     };
  #   }
  # ];

  # # Configuration fine de la session GNOME via Home Manager
  # home-manager.users."chomiam" = {
  #   dconf.settings = {
  #     # Applications favorites épinglées dans le dock/dash GNOME
  #     "org/gnome/shell" = {
  #       favorite-apps = [
  #         "org.gnome.Console.desktop"
  #         "org.gnome.Nautilus.desktop"
  #         "io.github.kolunmi.Bazaar.desktop"
  #         "google-chrome.desktop"
  #         "discord.desktop"
  #         "steam.desktop"
  #         "net.lutris.Lutris.desktop"
  #         "com.heroicgameslauncher.hgl.desktop"
  #         "onlyoffice-desktopeditors.desktop"
  #         "thunderbird.desktop"
  #         "com.obsproject.Studio.desktop"
  #         "zed-editor.desktop"
  #       ];
  #     };

  #     # Options expérimentales du gestionnaire de fenêtres Mutter
  #     "org/gnome/mutter" = {
  #       experimental-features = [
  #         "scale-monitor-framebuffer" # Améliore la gestion du scaling fractionnaire sur les écrans Haute Définition (HiDPI)
  #         "xwayland-native-scaling" # Permet le rendu net des anciennes applications X11/XWayland avec scaling
  #       ];
  #     };

  #     # Couleur d'accentuation de l'interface GNOME
  #     "org/gnome/desktop/interface" = {
  #       accent-color = "purple"; # Applique la couleur violette sur les boutons, curseurs et éléments actifs
  #     };

  #     # Configuration personnalisée du dock (Dash to Dock)
  #     "org/gnome/shell/extensions/dash-to-dock" = {
  #       dock-position = "LEFT"; # Positionne le dock sur le côté gauche de l'écran
  #       dock-fixed = true; # Conserve le dock visible en permanence (désactive le masquage automatique)
  #       extend-height = true; # Étire la barre du dock sur toute la hauteur de l'écran (style Unity)
  #       dash-max-icon-size = 48; # Taille maximale des icônes d'applications dans le dock (en pixels)
  #     };
  #   };

  #   # Variables d'environnement de session
  #   home.sessionVariables = {
  #     "MUTTER_DEBUG_FORCE_KMS_MODE" = "simple"; # Force le mode KMS simple sur Mutter (utile pour contourner certains soucis d'affichage)
  #   };
  # };

  # -----------------------------------------------------------------------
  # 🔴 2. KDE PLASMA 6 (INACTIF)
  # -----------------------------------------------------------------------
  # services.xserver.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # stylix.targets.kde.enable = true;

  # users.users."chomiam".packages = with pkgs; [
  #   kdePackages.kate
  #   # Ajoute tes paquets KDE ici
  # ];

  # home-manager.users."chomiam" = {
  #   home.sessionVariables = {
  #     "KWIN_DRM_USE_MODIFIER" = "0";
  #   };
  # };

  # -----------------------------------------------------------------------
  # 🔴 3. HYPRLAND (INACTIF)
  # -----------------------------------------------------------------------
  programs.hyprland.enable = true;
  programs.waybar.enable = true;

  users.users."chomiam".packages = with pkgs; [
    wofi
    dunst
    kitty
    hyprpaper
    pavucontrol
    grim
    slurp
    wl-clipboard
    nautilus
    mpvpaper
    waypaper
    wlogout
  ];

  home-manager.users."chomiam" = {
    home.sessionVariables = {
      "KWIN_DRM_USE_MODIFIER" = "0";
    };

    # Génération du fichier de configuration pour Hyprpaper
    xdg.configFile."hypr/hyprpaper.conf".text =
      let
        catppuccinWallpaper = pkgs.fetchurl {
          name = "catppuccin-wallpaper.png"; # <-- LIGNE À AJOUTER
          url = "https://cf.preview.redd.it/catppuccin-forest-at-night-3840x2160-with-imagegonord-v0-ggwlm12h9kl81.png?auto=webp&s=aa004f803703ddb276605224e2c799f57ad51ce7";
          sha256 = "0ncnd5m1wcgz9dabxc5y2rzcfm8zcz5qcjciazkqa2may1q0a94k";
        };
      in
      ''
        preload = ${catppuccinWallpaper}
        wallpaper = ,${catppuccinWallpaper}
        splash = false
      '';
  };

  # -----------------------------------------------------------------------
  # 🔴 4. COSMIC (INACTIF)
  # -----------------------------------------------------------------------
  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;

  # -----------------------------------------------------------------------
  # 🔴 5. CINNAMON (INACTIF)
  # -----------------------------------------------------------------------

  # # Activation de Cinnamon (fournit les sessions X11 et Wayland)
  # services.xserver.enable = true;
  # services.xserver.desktopManager.cinnamon.enable = true;

  # # Display Manager (GDM est recommandé sous Wayland)
  # services.xserver.displayManager.gdm.enable = true;

  # # Définition de la session Wayland par défaut
  # services.displayManager.defaultSession = "cinnamon-wayland";

  # # 2. Activation de dconf au niveau système (requis)
  # programs.dconf.enable = true;

  # # 3. Exclure gnome-screenshot pour éviter tout conflit
  # environment.gnome.excludePackages = with pkgs; [
  #   gnome-screenshot
  # ];

  # # 4. Paquets utilisateur
  # users.users."chomiam".packages = with pkgs; [
  #   xclip
  #   flameshot
  # ];

  # # 5. Configuration dconf au niveau NixOS système
  # programs.dconf.profiles.user.databases = [
  #   {
  #     settings = {
  #       # --- Raccourcis clavier pour Flameshot ---

  #       # Déclarer l'existence du raccourci personnalisé
  #       "org/cinnamon/desktop/keybindings" = {
  #         custom-list = [ "custom0" ];
  #       };

  #       # Définir le raccourci custom0 pour Flameshot
  #       "org/cinnamon/desktop/keybindings/custom-keybindings/custom0" = {
  #         binding = [ "Print" ];
  #         command = "flameshot gui";
  #         name = "Flameshot Capture";
  #       };

  #       # Libérer la touche Print des commandes de capture natives
  #       "org/cinnamon/desktop/keybindings/media-keys" = {
  #         screenshot = [ "" ];
  #         area-screenshot = [ "" ];
  #         window-screenshot = [ "" ];
  #       };

  #       # --- Applications favoris épinglées au panneau Cinnamon ---

  #       # Pour l'applet par défaut (Grouped Window List)
  #       "org/cinnamon/panel-launchers" = {
  #         pinned-app-list = [
  #           "org.gnome.Console.desktop"
  #           "org.gnome.Nautilus.desktop"
  #           "io.github.kolunmi.Bazaar.desktop"
  #           "google-chrome.desktop"
  #           "discord.desktop"
  #           "steam.desktop"
  #           "net.lutris.Lutris.desktop"
  #           "com.heroicgameslauncher.hgl.desktop"
  #           "onlyoffice-desktopeditors.desktop"
  #           "thunderbird.desktop"
  #           "com.obsproject.Studio.desktop"
  #         ];
  #       };

  #       # Rétrocompatibilité pour les lanceurs de panneau classiques
  #       "org/cinnamon" = {
  #         panel-launchers = [
  #           "org.gnome.Console.desktop"
  #           "org.gnome.Nautilus.desktop"
  #           "io.github.kolunmi.Bazaar.desktop"
  #           "google-chrome.desktop"
  #           "dev.vencord.Vesktop.desktop"
  #           "steam.desktop"
  #           "net.lutris.Lutris.desktop"
  #           "com.heroicgameslauncher.hgl.desktop"
  #           "onlyoffice-desktopeditors.desktop"
  #           "thunderbird.desktop"
  #           "com.obsproject.Studio.desktop"
  #         ];
  #       };
  #     };
  #   }
  # ];
  # -----------------------------------------------------------------------
  # 🔴 6. BUDGIE (INACTIF)
  # -----------------------------------------------------------------------
  # services.xserver.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.desktopManager.budgie.enable = true;
}
