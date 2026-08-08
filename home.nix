{
  config,
  pkgs,
  lib,
  ...
}:

{
  # =========================================================================
  # 👤 UTILISATEUR & SYSTÈME
  # =========================================================================
  home.username = "chomiam";
  home.homeDirectory = "/home/chomiam";

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  # =========================================================================
  # 📦 PAQUETS UTILISATEUR
  # =========================================================================
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # =========================================================================
  # 🖱️ CONFIGURATION DU CURSEUR
  # =========================================================================
  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

# =========================================================================
  # 🚪 MENU DE DÉCONNEXION (WLOGOUT)
  # =========================================================================
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "󰌾  Déconnecter";
        keybind = "l";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "󰜉  Redémarrer";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "󰐥  Éteindre";
        keybind = "s";
      }
    ];
};








  # =========================================================================
  # 🔐 VERROUILLAGE D'ÉCRAN (HYPRLOCK)
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
          outer_color = "rgba(122, 162, 247, 1.0)";
          inner_color = "rgba(26, 27, 38, 0.8)";
          font_color = "rgba(192, 202, 245, 1.0)";
          placeholder_text = "Mot de passe...";
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "rgba(192, 202, 245, 1.0)";
          font_size = 64;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # =========================================================================
  # 🚀 LANCEUR D'APPLICATIONS (WOFI)
  # =========================================================================
  programs.wofi = {
    enable = true;

    settings = {
      allow_images = true;
      image_size = 28;
      show = "drun";
      width = "30%";
      height = "40%";
      location = "center";
      prompt = " Rechercher...";
      matching = "fuzzy";
      insensitive = true;
    };

    style = ''
      window {
        margin: 0px;
        background-color: rgba(26, 27, 38, 0.95);
        border: 2px solid #7aa2f7;
        border-radius: 12px;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 14px;
      }

      #input {
        margin: 10px;
        padding: 8px 12px;
        border: none;
        border-radius: 8px;
        color: #c0caf5;
        background-color: #24283b;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #c0caf5;
      }

      #entry:selected {
        background-color: #7aa2f7;
        border-radius: 8px;
      }

      #entry:selected #text {
        color: #15161e;
        font-weight: bold;
      }

      #img {
        margin-right: 10px;
        background-color: transparent;
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
        spacing = 4;

        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "tray" "custom/power" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };

        "clock" = {
          format = "{:%H:%M - %d/%m/%Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "cpu" = {
          format = "CPU {usage}%";
          interval = 2;
        };

        "memory" = {
          format = "RAM {}%";
          interval = 2;
        };

        "network" = {
          format-wifi = "WiFi ({signalStrength}%)";
          format-ethernet = "Eth";
          format-disconnected = "Déconnecté";
          tooltip-format = "{ifname} via {gwaddr}";
        };

        "pulseaudio" = {
          format = "Vol {volume}%";
          format-muted = "Muet";
          on-click = "pavucontrol";
        };

        "tray" = {
          spacing = 10;
        };

        # --- Bouton d'alimentation ---
        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout";
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(26, 27, 38, 0.85);
        color: #c0caf5;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: #a9b1d6;
      }

      #workspaces button.active {
        background-color: #7aa2f7;
        color: #15161e;
        border-radius: 4px;
      }

      #clock, #cpu, #memory, #network, #pulseaudio, #tray {
        padding: 0 10px;
        margin: 3px 2px;
        background-color: #24283b;
        border-radius: 4px;
      }

      #custom-power {
        padding: 0 10px;
        margin: 3px 2px;
        background-color: #f7768e;
        color: #15161e;
        border-radius: 4px;
        font-weight: bold;
      }

      #clock {
        color: #7dcfff;
        font-weight: bold;
      }

      #pulseaudio {
        color: #f7768e;
      }

      #network {
        color: #73daca;
      }

      #cpu, #memory {
        color: #e0af68;
      }
    '';
  };

  # =========================================================================
  # ⚙️ CONFIGURATION GNOME & DCONF
  # =========================================================================
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
      experimental-features = lib.hm.gvariant.mkArray "s" [
        "scale-monitor-framebuffer"
        "xwayland-native-scaling"
      ];
    };

    "org/gnome/desktop/interface" = {
      accent-color = "purple";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "LEFT";
      dock-fixed = true;
      extend-height = true;
      dash-max-icon-size = 48;
    };
  };

  # =========================================================================
  # 🌐 VARIABLES D'ENVIRONNEMENT
  # =========================================================================
  home.sessionVariables = {
    "KWIN_DRM_USE_MODIFIER" = "0";
    "MUTTER_DEBUG_FORCE_KMS_MODE" = "simple";
  };

  # =========================================================================
  # 📁 FICHIERS DE CONFIGURATION XDG
  # =========================================================================
  xdg.configFile."fastfetch/config.jsonc".source =
    "${pkgs.fastfetch}/share/fastfetch/presets/examples/13.jsonc";
}
