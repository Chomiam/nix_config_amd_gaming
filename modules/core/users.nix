{ pkgs, vars, ... }:

{
  # =========================================================================
  # 👤 GESTION DES UTILISATEURS ET PAQUETS SYSTÈME / UTILISATEUR
  # =========================================================================

  # Compte Utilisateur Principal (basé sur vars.nix)
  users.users."${vars.user.username}" = {
    isNormalUser = true;
    description = vars.user.fullName;
    extraGroups = vars.user.extraGroups;
    shell = pkgs.${vars.user.shell};

    packages = with pkgs; [
      # 📺 Multimédia
      stremio-linux-shell
      vlc
      mpv

      # 💼 Productivité & Bureautique
      google-chrome
      firefox
      discord
      onlyoffice-desktopeditors
      thunderbird
      popsicle
      bazaar
      nil
      antigravity

      # 🛠️ Outils CLI & Shell
      fzf
      grc
      btop
      fastfetch
      git
      fishPlugins.done
      fishPlugins.fzf-fish
      fishPlugins.forgit
      fishPlugins.hydro
      fishPlugins.grc

      # 🌐 Réseau
      tailscale
    ];
  };

  # Activation du Shell Fish
  programs.fish = {
    enable = true;
    interactiveShellInit = "set fish_greeting";
  };

  # Paquets Système Utilitaires
  environment.systemPackages = with pkgs; [
    # 🖥️ Interface & Rendu GTK
    adw-gtk3
    libadwaita
    libappindicator-gtk3

    # 📦 Compression & Archives
    gnutar
    libarchive
    p7zip
    unrar
    unzip

    # 🔤 Polices d'écriture
    font-awesome
    noto-fonts

    # 🛠️ Outils Système
    nh
    fuse3
    python3
    curl
    wget
    libva-utils
    libxcb
    killall
  ];
}
