{ pkgs, ... }:

{
  # =========================================================================
  # 📁 EXPLORATEUR DE FICHIERS TUI (YAZI)
  # =========================================================================
  programs.yazi = {
    enable = true;

    # Intégration du wrapper Fish shell (commande 'y')
    enableFishIntegration = true;

    # Outils CLI d'extraction injectés dans le PATH de Yazi
    extraPackages = with pkgs; [
      ouch        # Décompresseur universel
      p7zip       # Support 7z / zip / rar
      unar        # Support multi-formats / encodages
    ];

    # -----------------------------------------------------------------------
    # PLUGINS
    # -----------------------------------------------------------------------
    plugins = {
      lin-decompress = pkgs.fetchFromGitHub {
        owner = "ZimCodes";
        repo = "lin-decompress.yazi";
        rev = "main";
        hash = "sha256-25lmX2hHfe8at/3gJ4vB8MiCRE+QR46rt3jCpF/fiX4="; # Hash temporaire
      };
    };

    # -----------------------------------------------------------------------
    # RACCOURCIS CLAVIER (KEYMAP)
    # -----------------------------------------------------------------------
    keymap = {
      manager.prepend_keymap = [
        {
          on = [ "e" "x" ];
          run = "plugin lin-decompress";
          desc = "Extraire l'archive";
        }
      ];
    };

    # -----------------------------------------------------------------------
    # CONFIGURATION PRINCIPALE (yazi.toml)
    # -----------------------------------------------------------------------
    settings = {
      manager = {
        show_hidden = true;       # Affiche les fichiers cachés
        sort_by = "alphabetical"; # Tri alphabétique
        sort_sensitive = false;   # Insensible à la casse
        sort_dir_first = true;    # Dossiers en haut
        linemode = "size";        # Affichage de la taille
      };

      preview = {
        tab_size = 2;
        max_width = 1000;
        max_height = 1000;
      };

      opener = {
        edit = [
          { run = ''nvim "$@"''; block = true; for = "unix"; }
        ];
      };
    };
  };
}
