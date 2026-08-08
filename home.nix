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
  # 📦 PAQUETS UTILISATEUR & POLICES
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
  # 💻 TERMINAL (KITTY - CATPPUCCIN MOCHA)
  # =========================================================================
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";

    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 11;
      background_opacity = "0.90";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 8;
    };
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
  # 🔐 VERROUILLAGE D'ÉCRAN (HYPRLOCK - CATPPUCCIN MOCHA)
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
          outer_color = "rgba(137, 180, 250, 1.0)"; # Blue (Catppuccin)
          inner_color = "rgba(30, 30, 46, 0.85)";  # Base (Catppuccin)
          font_color = "rgba(205, 214, 244, 1.0)";  # Text (Catppuccin)
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
          color = "rgba(205, 214, 244, 1.0)";
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
  # 🚀 LANCEUR D'APPLICATIONS (WOFI - CATPPUCCIN MOCHA)
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
        background-color: rgba(30, 30, 46, 0.95);
        border: 2px solid #89b4fa;
        border-radius: 12px;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 14px;
      }

      #input {
        margin: 10px;
        padding: 8px 12px;
        border: none;
        border-radius: 8px;
        color: #cdd6f4;
        background-color: #313244;
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
        color: #cdd6f4;
      }

      #entry:selected {
        background-color: #89b4fa;
        border-radius: 8px;
      }

      #entry:selected #text {
        color: #11111b;
        font-weight: bold;
      }

      #img {
        margin-right: 10px;
        background-color: transparent;
      }
    '';
  };

  # =========================================================================
  # 📊 BARRE D'ÉTAT (WAYBAR - CATPPUCCIN MOCHA)
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
        background-color: rgba(30, 30, 46, 0.85);
        color: #cdd6f4;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: #a6adc8;
      }

      #workspaces button.active {
        background-color: #89b4fa;
        color: #11111b;
        border-radius: 4px;
      }

      #clock, #cpu, #memory, #network, #pulseaudio, #tray {
        padding: 0 10px;
        margin: 3px 2px;
        background-color: #313244;
        border-radius: 4px;
      }

      #custom-power {
        padding: 0 10px;
        margin: 3px 2px;
        background-color: #f38ba8;
        color: #11111b;
        border-radius: 4px;
        font-weight: bold;
      }

      #clock {
        color: #89dceb;
        font-weight: bold;
      }

      #pulseaudio {
        color: #f38ba8;
      }

      #network {
        color: #a6e3a1;
      }

      #cpu, #memory {
        color: #f9e2af;
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
