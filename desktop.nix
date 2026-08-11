{
  config,
  pkgs,
  lib,
  ...
}:

{
  # =======================================================================
  # 🖥️ GESTIONNAIRE D'ENVIRONNEMENT DE BUREAU
  # =======================================================================

  # -----------------------------------------------------------------------
  # 🟢 1. GNOME
  # -----------------------------------------------------------------------

  # Active le serveur graphique X11
  services.xserver.enable = true;

  # Active le gestionnaire de connexion graphique GDM
  services.displayManager.gdm.enable = true;

  # Active l'environnement de bureau GNOME Shell
  services.desktopManager.gnome.enable = true;

  # Liste des applications GNOME par défaut à ne pas installer sur le système
  environment.gnome.excludePackages = with pkgs; [
    totem
    gnome-maps
    yelp
    gnome-tour
    epiphany
  ];

  # Outils et extensions GNOME installés pour l'utilisateur "chomiam"
  users.users."chomiam".packages = with pkgs; [
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.vitals
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.arcmenu
  ];

  # Activation système des extensions GNOME via dconf
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/shell" = {
          enabled-extensions = [
            "blur-my-shell@aunetx"
            "appindicatorsupport@rgcjonas.gmail.com"
            "Vitals@CoreCoding.com"
            "clipboard-indicator@tudmotu.com"
            "arcmenu@arcmenu.com"
          ];
        };
      };
    }
  ];

  # Configuration fine de la session GNOME via Home Manager
  home-manager.users."chomiam" = {
    dconf.settings = {
      # Applications favorites épinglées dans le dock/dash GNOME
      "org/gnome/shell" = {
        favorite-apps = [
          "Alacritty.desktop"
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
          "zed-editor.desktop"
        ];
      };

      # Options expérimentales du gestionnaire de fenêtres Mutter
      "org/gnome/mutter" = {
        experimental-features = [
          "scale-monitor-framebuffer"
          "xwayland-native-scaling"
          "hdr"
        ];
      };

      # Couleur d'accentuation de l'interface GNOME
      "org/gnome/desktop/interface" = {
        accent-color = "purple";
      };

      # Configuration personnalisée du dock (Dash to Dock)
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-position = "LEFT";
        dock-fixed = true;
        extend-height = true;
        dash-max-icon-size = 48;
      };
    };
  };
}
