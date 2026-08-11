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
  #
  # # Active le serveur graphique X11
  # services.xserver.enable = true;
  #
  # # Active le gestionnaire de connexion graphique GDM
  # services.displayManager.gdm.enable = true;
  #
  # # Active l'environnement de bureau GNOME Shell
  # services.desktopManager.gnome.enable = true;
  #
  # # Liste des applications GNOME par défaut à ne pas installer sur le système
  # environment.gnome.excludePackages = with pkgs; [
  #   totem
  #   gnome-maps
  #   yelp
  #   gnome-tour
  #   epiphany
  # ];
  #
  # # Outils et extensions GNOME installés pour l'utilisateur "chomiam"
  # users.users."chomiam".packages = with pkgs; [
  #   gnome-tweaks
  #   gnome-extension-manager
  #   gnomeExtensions.dash-to-dock
  #   gnomeExtensions.blur-my-shell
  #   gnomeExtensions.appindicator
  #   gnomeExtensions.vitals
  #   gnomeExtensions.clipboard-indicator
  #   gnomeExtensions.arcmenu
  # ];
  #
  # # Activation système des extensions GNOME via dconf
  # programs.dconf.profiles.user.databases = [
  #   {
  #     settings = {
  #       "org/gnome/shell" = {
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
  #
  # # Configuration fine de la session GNOME via Home Manager
  # home-manager.users."chomiam" = {
  #   dconf.settings = {
  #     # Applications favorites épinglées dans le dock/dash GNOME
  #     "org/gnome/shell" = {
  #       favorite-apps = [
  #         "Alacritty.desktop"
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
  #
  #     # Options expérimentales du gestionnaire de fenêtres Mutter
  #     "org/gnome/mutter" = {
  #       experimental-features = [
  #         "scale-monitor-framebuffer"
  #         "xwayland-native-scaling"
  #       ];
  #     };
  #
  #     # Couleur d'accentuation de l'interface GNOME
  #     "org/gnome/desktop/interface" = {
  #       accent-color = "purple";
  #     };
  #
  #     # Configuration personnalisée du dock (Dash to Dock)
  #     "org/gnome/shell/extensions/dash-to-dock" = {
  #       dock-position = "LEFT";
  #       dock-fixed = true;
  #       extend-height = true;
  #       dash-max-icon-size = 48;
  #     };
  #   };
  #
  #   # Variables d'environnement de session
  #   home.sessionVariables = {
  #     "MUTTER_DEBUG_FORCE_KMS_MODE" = "simple";
  #   };
  # };
  # -----------------------------------------------------------------------
  # 🔴 2. KDE PLASMA 6 (INACTIF)
  # -----------------------------------------------------------------------
  # ===========================================================================
  # 🖥️  SERVICES SYSTÈME & BUREAU (KDE PLASMA 6)
  # ===========================================================================
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # ===========================================================================
  # 🧹  EXCLUSION DES APPLICATIONS KDE PAR DÉFAUT
  # ===========================================================================
  # Retire du système les paquets natifs de KDE que tu ne souhaites pas utiliser
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole          # Terminal KDE
    discover         # Centre de logiciels
    khelpcenter      # Centre d'aide
    okular           # Lecteur de documents / PDF
    kate             # Éditeur de texte
    elisa            # Lecteur audio
  ];

  # ===========================================================================
  # 👤  UTILISATEUR "chomiam"
  # ===========================================================================
  # Note : La déclaration des paquets (packages = [ ... ]) est gérée dans ton
  # autre fichier de configuration.
  users.users."chomiam" = {
    # Vos paramètres utilisateur habituels (ex: isNormalUser = true;)
  };

  # ===========================================================================
  # 🏠  CONFIGURATION HOME-MANAGER
  # ===========================================================================
  home-manager.users."chomiam" = {

    # ⚙️  Variables de session
    home.sessionVariables = {
      "KWIN_DRM_USE_MODIFIER" = "0";
    };

    # 📌  Configuration déclarative du bureau KDE (via plasma-manager)
    programs.plasma = {
      enable = true;
      overrideConfig = true; # Autorise plasma-manager à appliquer la config par-dessus l'existante

      # Configuration du panneau principal (barre des tâches)
      panels = [
        {
          location = "bottom";
          height = 44;

          # Composants (widgets) intégrés au panneau
          widgets = [
            # 🚀 Menu d'applications Kickoff
            "org.kde.plasma.kickoff"

            # 📌 Liste des applications épinglées
            {
              iconTasks = {
                launchers = [
                  "applications:Alacritty.desktop"
                  "applications:org.kde.dolphin.desktop"        # Dolphin à la place de Nautilus
                  "applications:io.github.kolunmi.Bazaar.desktop"
                  "applications:google-chrome.desktop"
                  "applications:discord.desktop"
                  "applications:steam.desktop"
                  "applications:net.lutris.Lutris.desktop"
                  "applications:com.heroicgameslauncher.hgl.desktop"
                  "applications:onlyoffice-desktopeditors.desktop"
                  "applications:thunderbird.desktop"
                  "applications:com.obsproject.Studio.desktop"
                ];
              };
            }

            # 📐 Espacement et zone système
            "org.kde.plasma.marginsseparator"
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
          ];
        }
      ];
    };
  };

  # -----------------------------------------------------------------------
  # 🔴 3. HYPRLAND (INACTIF)
  # -----------------------------------------------------------------------
  # programs.hyprland.enable = true;
  # programs.waybar.enable = true;
  #
  # users.users."chomiam".packages = with pkgs; [
  #   wofi
  #   dunst
  #   kitty
  #   hyprpaper
  #   pavucontrol
  #   grim
  #   slurp
  #   nautilus
  #   wl-clipboard
  #
  # ];
  #
  # home-manager.users."chomiam" = {
  #   home.sessionVariables = {
  #     "KWIN_DRM_USE_MODIFIER" = "0";
  #   };
  #
  #   # Génération du fichier de configuration pour Hyprpaper
  #   xdg.configFile."hypr/hyprpaper.conf".text =
  #     let
  #       catppuccinWallpaper = pkgs.fetchurl {
  #         name = "catppuccin-wallpaper.png"; # <-- LIGNE À AJOUTER
  #         url = "https://cf.preview.redd.it/catppuccin-forest-at-night-3840x2160-with-imagegonord-v0-ggwlm12h9kl81.png?auto=webp&s=aa004f803703ddb276605224e2c799f57ad51ce7";
  #         sha256 = "0ncnd5m1wcgz9dabxc5y2rzcfm8zcz5qcjciazkqa2may1q0a94k";
  #       };
  #     in
  #     ''
  #       preload = ${catppuccinWallpaper}
  #       wallpaper = ,${catppuccinWallpaper}
  #       splash = false
  #     '';
  # };

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
