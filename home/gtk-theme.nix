{ pkgs, lib, config, ... }:

{
  # =========================================================================
  # 🎨 THÈME GTK, ICÔNES & CURSEUR
  # =========================================================================

  gtk = {
    enable = true;

    gtk2.extraConfig = "gtk-application-prefer-dark-theme = 1";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;

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

  # Activation déclarative du mode sombre pour GTK4/Libadwaita, Nautilus, Firefox & Chrome
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
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
}
