{ pkgs, ... }:

{
  # Configuration globale du paquet Neovim pour NixOS
  programs.neovim = {
    enable = true;
    defaultEditor = true; # Définit Neovim comme éditeur par défaut ($EDITOR)
    viAlias = true;        # Mappe la commande 'vi' vers 'nvim'
    vimAlias = true;       # Mappe la commande 'vim' vers 'nvim'

    # Bloc de configuration spécifique au module système NixOS
    configure = {
      
      # -----------------------------------------------------------------------
      # 1. DÉCLARATION ET CHARGEMENT DES PLUGINS (Syntaxe Nix : '#')
      # -----------------------------------------------------------------------
      packages.myPlugins = with pkgs.vimPlugins; {
        start = [
          catppuccin-nvim    # Thème visuel Catppuccin
          nvim-web-devicons  # Icônes pour l'interface et le picker
          snacks-nvim        # Suite d'outils UI et Picker (Snacks.picker)
          grug-far-nvim      # Outil de recherche et remplacement projet (Search & Replace)
        ];
      };

      # -----------------------------------------------------------------------
      # 2. CONFIGURATION LUA D'INITIALISATION (customRC)
      # -----------------------------------------------------------------------
      customRC = ''
        lua << EOF
        -----------------------------------------------------------------------
        -- A. OPTIONS DE NAVIGATION & SOURIS (Syntaxe Lua : '--')
        -----------------------------------------------------------------------
        vim.opt.number = true          -- Affiche les numéros de ligne
        vim.opt.relativenumber = true  -- Numéros relatifs (pratique pour les mouvements 5j / 10k)
        vim.opt.mouse = "a"            -- Active la prise en charge complète de la souris

        -- Double-clic pour entrer directement en mode insertion
        vim.keymap.set("n", "<2-LeftMouse>", "<LeftMouse>i", { desc = "Double-clic pour éditer" })

        -----------------------------------------------------------------------
        -- B. GESTION DES TABULATIONS ET DE L'INDENTATION
        -----------------------------------------------------------------------
        vim.opt.expandtab = true       -- Convertit les appuis sur <Tab> en espaces
        vim.opt.shiftwidth = 2        -- Nombre d'espaces insérés pour une indentation (Nix/Lua)
        vim.opt.tabstop = 2           -- Largeur d'affichage d'un caractère Tab
        vim.opt.softtabstop = 2       -- Nombre d'espaces insérés lors de la frappe
        vim.opt.autoindent = true      -- Conserve le niveau d'indentation de la ligne précédente
        vim.opt.smartindent = true     -- Adapte l'indentation automatiquement selon la syntaxe

        -----------------------------------------------------------------------
        -- C. THÈME ET APPARENCE
        -----------------------------------------------------------------------
        vim.cmd.colorscheme("catppuccin-mocha") -- Applique le thème Catppuccin (variante Mocha)

        -----------------------------------------------------------------------
        -- D. CONFIGURATION DE SNACKS.NVIM (Picker & Recherche rapide)
        -----------------------------------------------------------------------
        local snacks = require("snacks")
        
        snacks.setup({
          picker = { enabled = true },
        })

        -- Raccourcis clavier pour le picker
        vim.keymap.set("n", "<leader>ff", function() snacks.picker.files() end, { desc = "Rechercher des fichiers" })
        vim.keymap.set("n", "<leader>fg", function() snacks.picker.grep() end,  { desc = "Rechercher du texte (Grep)" })
        vim.keymap.set("n", "<leader>fb", function() snacks.picker.buffers() end, { desc = "Lister les buffers ouverts" })

        -----------------------------------------------------------------------
        -- E. CONFIGURATION DE GRUG-FAR (Search & Replace global)
        -----------------------------------------------------------------------
        require("grug-far").setup({})

        -- Raccourci pour ouvrir le panneau de recherche et remplacement
        vim.keymap.set("n", "<leader>sr", function() require("grug-far").open() end, { desc = "Ouvrir Search & Replace projet" })
        EOF
      '';
    };
  };
}
