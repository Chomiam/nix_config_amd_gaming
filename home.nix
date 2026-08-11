{
  config,
  pkgs,
  lib,
  ...
}:

{
  # =========================================================================
  # 👤 INFORMATIONS UTILISATEUR & SYSTÈME
  # =========================================================================
  home = {
    username = "chomiam";
    homeDirectory = "/home/chomiam";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;

  # =========================================================================
  # 🎨 CONFIGURATION GLOBALE CATPPUCCIN (MOCHA)
  # =========================================================================
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "lavender";

    alacritty.enable = true;
  };

  # =========================================================================
  # 🎨 THÈME GTK, CURSEUR & ICÔNES
  # =========================================================================
  gtk = {
    enable = true;

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = lib.mkForce (
        pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "lavender";
        }
      );
    };
  };

  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # =========================================================================
  # 📦 PAQUETS UTILISATEUR & SERVICES
  # =========================================================================
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  services.easyeffects.enable = true;

  # =========================================================================
  # 💻 TERMINAL PRINCIPAL (ALACRITTY)
  # =========================================================================
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        padding = {
          x = 8;
          y = 8;
        };
        opacity = 0.90;
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = 11;
      };

      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
      };
    };
  };

  # =========================================================================
  # ⚙️ PARAMÈTRES GNOME / DCONF
  # =========================================================================
  dconf.settings = {
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "alacritty";
      exec-arg = "-e";
    };

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
      ];
    };

    "org/gnome/mutter" = {
      experimental-features = [
        "scale-monitor-framebuffer"
        "xwayland-native-scaling"
        "hdr"
      ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
      accent-color = "purple";
    };
  };

  # =========================================================================
  # 🌐 VARIABLES D'ENVIRONNEMENT & XDG
  # =========================================================================
  home.sessionVariables = {
    TERMINAL = "alacritty";
  };

  xdg.configFile."fastfetch/config.jsonc".source =
    "${pkgs.fastfetch}/share/fastfetch/presets/examples/13.jsonc";
}
