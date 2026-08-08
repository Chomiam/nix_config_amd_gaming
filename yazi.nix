{ pkgs, ... }:

{
  # =========================================================================
  # 📁 EXPLORATEUR DE FICHIERS TUI (YAZI)
  # =========================================================================
  programs.yazi = {
    enable = true;

    # Génère le wrapper Fish pour que 'y' change le $PWD du terminal
    enableFishIntegration = true;

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

      # Configuration de Neovim comme éditeur texte par défaut
      opener = {
        edit = [
          { run = ''nvim "$@"''; block = true; for = "unix"; }
        ];
      };
    };
  };
}
