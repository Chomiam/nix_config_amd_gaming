{ pkgs, ... }:

{
  # =========================================================================
  # 📁 EXPLORATEUR DE FICHIERS TUI (YAZI)
  # =========================================================================
  programs.yazi = {
    enable = true;

    # Active l'intégration dans les shells (fournit la commande `y` qui change
    # automatiquement le répertoire du terminal lors de la fermeture)
    enableFishIntegration = true;
    enableBashIntegration = true;

    # -----------------------------------------------------------------------
    # CONFIGURATION PRINCIPALE (yazi.toml)
    # -----------------------------------------------------------------------
    settings = {
      manager = {
        show_hidden = true;       # Affiche les fichiers cachés par défaut
        sort_by = "alphabetical"; # Tri alphabétique
        sort_sensitive = false;  # Insensible à la casse
        sort_dir_first = true;    # Dossiers placés en haut de liste
        linemode = "size";        # Affiche la taille des fichiers dans la colonne
      };

      preview = {
        tab_size = 2;
        max_width = 1000;
        max_height = 1000;
      };

      # Ouvreurs par défaut (définit Neovim pour l'édition de fichiers texte)
      opener = {
        edit = [
          { run = ''nvim "$@"''; block = true; for = "unix"; }
        ];
      };
    };
  };
}
