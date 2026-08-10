{
  config,
  pkgs,
  lib,
  ...
}:

{
  # =========================================================================
  # 📦 IMPORTS DES MODULES SECONDAIRES
  # =========================================================================
  imports = [
    ./yazi.nix
    ./rmpc.nix
  ];

  # =========================================================================
  # 👤 INFORMATIONS UTILISATEUR & SYSTÈME
  # =========================================================================
  home.username = "chomiam";
  home.homeDirectory = "/home/chomiam";

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  # =========================================================================
  # 🎨 CONFIGURATION GLOBALE CATPPUCCIN (MOCHA)
  # =========================================================================
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "lavender";

    alacritty.enable = true;
    swaync.enable = false;
    waybar.enable = false;
  };

  # =========================================================================
  # 🎨 THÈME GTK & ICÔNES
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

  # =========================================================================
  # 📦 PAQUETS UTILISATEUR & POLICES
  # =========================================================================
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  services.easyeffects.enable = true;

  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # =========================================================================
  # 💻 TERMINAL PRINCIPAL (ALACRITTY - CATPPUCCIN MOCHA)
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
  # 🔔 NOTIFICATIONS (SWAYNC)
  # =========================================================================
  services.swaync = {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";
      control-center-width = 340;
      control-center-height = 500;
      fit-to-screen = false;

      widgets = [
        "title"
        "dnd"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Effacer";
        };
        dnd = {
          text = "Ne pas déranger";
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
      }
      .notification {
        border-radius: 12px;
        margin: 6px 8px;
        background: #1e1e2e;
      }
      .control-center {
        background: rgba(30, 30, 46, 0.95);
        border: 2px solid #89b4fa;
        border-radius: 16px;
        padding: 12px;
      }
    '';
  };

  # =========================================================================
  # 🔐 VERROUILLAGE (HYPRLOCK)
  # =========================================================================
  programs.hyprlock = {
    enable = true;

    settings = lib.mkForce {
      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          outline_thickness = 3;
          outer_color = "rgba(137, 180, 250, 1.0)";
          inner_color = "rgba(30, 30, 46, 0.85)";
          font_color = "rgba(205, 214, 244, 1.0)";
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "rgba(205, 214, 244, 1.0)";
          font_size = 64;
          font_family = "JetBrainsMono Nerd Font";
        }
      ];
    };
  };

  # =========================================================================
  # 🚪 DÉCONNEXION (WLOGOUT)
  # =========================================================================
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "Déconnecter";
        keybind = "d";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Redémarrer";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Éteindre";
        keybind = "e";
      }
    ];

    style = ''
      * {
        box-shadow: none;
        font-family: "JetBrainsMono Nerd Font", monospace;
      }
      window {
        background-color: rgba(36, 39, 58, 0.85);
      }
      button {
        border-radius: 16px;
        border: 2px solid #363a4f;
        color: #cad3f5;
        background-color: #1e2030;
        margin: 15px;
      }
    '';
  };

  # =========================================================================
  # 🚀 LANCEUR (WOFI)
  # =========================================================================
  programs.wofi = {
    enable = true;

    settings = {
      allow_images = true;
      show = "drun";
      width = "30%";
      height = "40%";
      location = "center";
    };

    style = ''
      window {
        background-color: rgba(30, 30, 46, 0.95);
        border: 2px solid #89b4fa;
        border-radius: 12px;
      }
      #input {
        margin: 10px;
        background-color: #313244;
        color: #cdd6f4;
      }
      #entry:selected {
        background-color: #89b4fa;
      }
    '';
  };

  # =========================================================================
  # 📊 BARRE D'ÉTAT (WAYBAR)
  # =========================================================================
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "network"
          "tray"
        ];
      };
    };

    style = ''
      * {
        border: none;
        font-family: "JetBrainsMono Nerd Font", monospace;
      }
      #waybar {
        background-color: rgba(30, 30, 46, 0.85);
        color: #cdd6f4;
      }
    '';
  };

  # =========================================================================
  # ⚙️ CONFIGURATION GNOME & DCONF
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
        "zed-editor.desktop"
      ];
    };

    "org/gnome/mutter" = {
      experimental-features = [
        "scale-monitor-framebuffer"
        "xwayland-native-scaling"
      ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
      accent-color = "purple";
    };
  };

  # =========================================================================
  # 🌐 VARIABLES D'ENVIRONNEMENT UTILISATEUR
  # =========================================================================
  home.sessionVariables = {
    "TERMINAL" = "alacritty";
  };

  xdg.configFile."fastfetch/config.jsonc".source =
    "${pkgs.fastfetch}/share/fastfetch/presets/examples/13.jsonc";
}
