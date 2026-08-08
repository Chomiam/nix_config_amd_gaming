{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Plugins installés via pkgs.vimPlugins
    plugins = with pkgs.vimPlugins; [
      # Thème et UI
      catppuccin-nvim
      nvim-web-devicons

      # Picker & Search
      snacks-nvim
      grug-far-nvim
    ];

    extraLuaConfig = ''
      -------------------------------------------------------------------------------
      -- 1. OPTIONS DE BASE (Numéros de ligne & Indentation)
      -------------------------------------------------------------------------------
      vim.opt.number = true          -- Affiche les numéros de ligne
      vim.opt.relativenumber = true  -- Numéros relatifs pour saut rapide (ex: 5j, 10k)
      vim.opt.mouse = "a"            -- Support complet de la souris

      -- Tabulations et espaces (2 espaces par défaut pour Nix/YAML/Lua)
      vim.opt.expandtab = true       -- Transforme les <Tab> en espaces
      vim.opt.shiftwidth = 2        -- Nombre d'espaces pour une indentation
      vim.opt.tabstop = 2           -- Affichage d'un caractère tab
      vim.opt.softtabstop = 2       -- Espaces insérés lors de la frappe
      vim.opt.autoindent = true      -- Conserve l'alignement de la ligne précédente
      vim.opt.smartindent = true     -- Indentation automatique selon le contexte

      -- Thème Catppuccin
      vim.cmd.colorscheme("catppuccin-mocha")

      -------------------------------------------------------------------------------
      -- 2. CONFIGURATION SNACKS.NVIM (Picker & Navigation)
      -------------------------------------------------------------------------------
      local snacks = require("snacks")
      snacks.setup({
        picker = { enabled = true },
      })

      -- Mappings pour Snacks.picker
      vim.keymap.set("n", "<leader>ff", function() snacks.picker.files() end, { desc = "Trouver fichiers" })
      vim.keymap.set("n", "<leader>fg", function() snacks.picker.grep() end, { desc = "Recherche texte (ripgrep)" })
      vim.keymap.set("n", "<leader>fb", function() snacks.picker.buffers() end, { desc = "Buffers ouverts" })

      -------------------------------------------------------------------------------
      -- 3. CONFIGURATION GRUG-FAR (Search & Replace projet)
      -------------------------------------------------------------------------------
      require("grug-far").setup({})

      vim.keymap.set("n", "<leader>sr", function() require("grug-far").open() end, { desc = "Search & Replace projet" })
    '';
  };
}
