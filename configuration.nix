{
  config,
  pkgs,
  lib,
  ...
}:

{
  # =======================================================================
  # 📁 IMPORTS
  # =======================================================================
  imports = [
    ./hardware-configuration.nix
#    ./stylix.nix
    ./desktop.nix # Gestionnaire centralisé d'environnement de bureau
    ./mount.nix # Configuration du montage du disque de jeux
    ./neovim.nix
  ];

  # =======================================================================
  # ⚙️ CONFIGURATION NIX & FLAKES
  # =======================================================================
  # Paramètres globaux du gestionnaire de paquets Nix
  nix.settings = {
    # Active les fonctionnalités expérimentales indispensables pour l'écosystème moderne
    # - "nix-command" : Active la nouvelle CLI Nix unifiée (`nix search`, `nix run`, `nix store`...)
    # - "flakes" : Active le support des Flakes pour une gestion déclarative et reproductible des dépendances
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Active l'optimisation et le dédoublonnage automatique du magasin /nix/store
    # Réduit l'espace disque utilisé en créant des liens physiques (hardlinks) entre les fichiers identiques
    auto-optimise-store = true;

  };

  # Jeton d'accès personnel GitHub (PAT)
  # Augmente le quota de requêtes (rate-limit) auprès de l'API GitHub pour éviter les blocages lors du téléchargement des Flakes
  #
  # 🔒 Inclusion sécurisée du token GitHub depuis un fichier externe non versionné
  nix.extraOptions = ''
    !include /etc/nixos/secrets/github-token.conf
  '';

  # Nettoyage automatique du système (Garbage Collector)
  nix.gc = {
    automatic = true; # Active le lancement automatique de la purge
    dates = "weekly"; # Planifie le nettoyage une fois par semaine
    options = "--delete-older-than 7d"; # Supprime toutes les générations système datant de plus de 7 jours
  };

  # Autorise l'installation des paquets propriétaires / non-libres (ex: pilotes AMD/Nvidia, Steam, Google Chrome, Discord)
  nixpkgs.config.allowUnfree = true;

  # =======================================================================
  # 🚀 BOOTLOADER & NOYAU (KERNEL)
  # =======================================================================
  boot = {
    # Version du kernel (XanMod Latest)
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    # Arguments de démarrage du noyau AMD
    kernelParams = [
      "quiet"
      "splash"
      "amdgpu.ppfeaturemask=0xffffffff"
    ];

    # Écran de démarrage Plymouth
    plymouth.enable = true;

    # Gestionnaire de démarrage GRUB
    loader = {
      # Temps d'attente (en secondes) du menu GRUB avant le démarrage automatique
      timeout = 3;

      # Configuration principale de GRUB
      grub = {
        enable = true; # Active le bootloader GRUB
        device = "nodev"; # "nodev" indique une installation UEFI (pas de MBR sur un disque spécifique)
        efiSupport = true; # Active la prise en charge de l'amorce UEFI
      };

      # Permet à NixOS d'écrire et mettre à jour les entrées de démarrage dans la NVRAM UEFI
      efi.canTouchEfiVariables = true;

      # Thème visuel pour le menu GRUB (Module Flake grub2-themes)
      grub2-theme = {
        enable = true; # Active le thème personnalisé
        theme = "tela"; # Utilise le thème "Tela"
        footer = true; # Affiche la barre d'aide / raccourcis en bas de l'écran
        customResolution = "2560x1440"; # Force la résolution native de l'écran (2.5K)
      };
    };

    # Modules matériels personnalisés
    extraModulePackages = with config.boot.kernelPackages; [
      new-lg4ff # Logitech (G29, G920, G923...)
      hid-tmff2 # Thrustmaster (T300, T150, TX...)
      hid-fanatecff # Fanatec (CSL, DD1/DD2, GT DD Pro...)
      zenpower # CPU AMD Ryzen Telemetry
    ];
    kernelModules = [ "zenpower" ];
    blacklistedKernelModules = [ "k10temp" ]; # Évite tout conflit avec zenpower
  };

  # Optimisations mémoire & Kernel Sysctl (Optimisé Gaming / ZRAM)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642; # Limite requise par SteamOS / Proton
    "vm.vfs_cache_pressure" = 100;
    "vm.swappiness" = 180; # Utilisation agressive de ZRAM
    "vm.page-cluster" = 0; # Latence I/O réduite pour ZRAM
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "kernel.split_lock_mitigate" = 0; # Suppression des micro-saccades CPU
  };

  # =======================================================================
  # 🌐 RÉSEAU & LOCALISATION
  # =======================================================================
  networking = {
    # Nom de la machine sur le réseau local
    hostName = "nixos";

    # Gestionnaire de connexions réseau (NetworkManager)
    networkmanager = {
      enable = true;

      # Paramètres avancés de NetworkManager
      settings = {
        connection = {
          # Désactive la mise en veille / économie d'énergie du Wi-Fi
          # Valeurs : 0 = défaut, 1 = ignorer, 2 = désactivé (performances max), 3 = activé
          # Évite les pertes de paquets, la latence en jeu et les déconnexions intempestives.
          "wifi.powersave" = 2;
        };
      };
    };

    # Serveurs DNS manuels (Cloudflare et Quad9)
    # Remplacent le DNS par défaut de ton fournisseur d'accès pour plus de rapidité/confidentialité
    nameservers = [
      "1.1.1.1"
      "9.9.9.9"
    ];
  };

  services.resolved.enable = true;
  time.timeZone = "Europe/Paris";
  console.keyMap = "fr";

  i18n = {
    defaultLocale = "fr_FR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  # Support Clavier X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # =======================================================================
  # 🔊 AUDIO & IMPRESSION
  # =======================================================================
  services.printing.enable = true;

  hardware.enableAllFirmware = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # =======================================================================
  # 👤 UTILISATEURS & APPS PERSO
  # =======================================================================
  users.users."chomiam" = {
    isNormalUser = true;
    description = "Axel Valens";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;

    packages = with pkgs; [

      # 🎮 Gaming & Multimédia
      lutris # Gestionnaire universel de jeux (GOG, Epic, Humble, emulators, etc.)
      heroic # Lanceur alternatif open-source pour Epic Games, GOG et Amazon Prime Games
      # pegasus-frontend # Frontend de gestionnaire de jeux pour Linux
      # retroarch # Emulateur de jeux pour Linux
      # ryubing # Emulateur de jeux nintendo Switch fork communautaire de Ryujinx
      eden # Emulateur de jeux nintendo Switch axé sur les hacks mod haute perf - stable
      ludusavi # Outil de sauvegarde automatique des sauvegardes (savegames) de jeux PC
      protonplus # Interface graphique pour télécharger/gérer GE-Proton, Wine-GE et DXVK facilement
      protontricks # Utilitaire pour installer des dépendances Windows dans les préfixes Proton
      mangohud # Overlay en jeu affichant FPS, températures CPU/GPU, utilisation RAM et VRAM
      goverlay # Interface graphique pour configurer MangoHud, vkBasalt et ReplaySorcery
      stremio-linux-shell # Interface Shell/Linux pour le lecteur multimédia et de streaming Stremio
      kodi # Centre multimédia complet pour la gestion de vos médias
      vlc # Lecteur média universel et léger pour tous formats
      easyeffects # Effets audio pour les applications Linux
      mpv      
      
      # 💼 Productivité & Bureautique
      google-chrome # Navigateur web Google Chrome
      discord # Client de messagerie et de communication en temps réel
      onlyoffice-desktopeditors # Suite bureautique complète (compatible MS Office : Word, Excel, PowerPoint)
      davinci-resolve # Logiciel de montage vidéo professionnel
      godot # Éditeur de jeux 2D/3D
      thunderbird # Client de messagerie électronique, calendrier et gestionnaire de contacts
      popsicle # Outil simple d'écriture d'images ISO sur plusieurs clés USB en parallèle
      bazaar # Boutique/catalogue d'applications alternatives pour Linux
      zed-editor # Éditeur de code ultra-rapide et moderne écrit en Rust
      nil # Language Server (LSP) pour le langage Nix (autocomplétion, diagnostic dans Zed/VSCode)

      # 🛠️ Outils CLI & Shell
      fzf # Outil de recherche floue (fuzzy finder) ultra-rapide dans le terminal
      grc # Generic Colouriser : ajoute de la couleur aux sorties de commandes (ping, netstat, etc.)
      btop # Moniteur de ressources système interactif et stylé (CPU, RAM, Disque, Réseau)
      fastfetch # Outil d'affichage des informations système ultra-rapide (alternative moderne à neofetch)
      git # Système de contrôle de version pour la gestion de code et de configurations
      fishPlugins.done # Plugin Fish : envoie une notification quand une commande longue est terminée
      fishPlugins.fzf-fish # Plugin Fish : intègre les raccourcis de recherche FZF directement dans le shell
      fishPlugins.forgit # Plugin Fish : intègre FZF avec Git pour visualiser les diffs/commits de manière interactive
      fishPlugins.hydro # Plugin Fish : prompt minimaliste, rapide et d'apparence moderne
      fishPlugins.grc # Plugin Fish : coloration automatique des commandes via GRC

      # 🌐 Réseau et Pare-feu
      tailscale # VPN mesh sécurisé basé sur WireGuard

    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = "set fish_greeting";
  };

  # =======================================================================
  # 🎮 PERFORMANCES GAMING & GRAPHISMES
  # =======================================================================
  environment.variables = {
    # Active l'implémentation OpenCL moderne basée sur Rust ("Rusticl")
    # spécifiquement pour le pilote d'affichage AMD Radeon ("radeonsi").
    # Indispensable pour que DaVinci Resolve utilise l'accélération GPU AMD sur Linux.
    RUSTICL_ENABLE = "radeonsi";
  };
  hardware.amdgpu.opencl.enable = true;
  # Configuration des pilotes et de l'accélération graphique
  hardware.graphics = {
    enable = true; # Active le support de l'accélération graphique (Mesa / Vulkan)
    enable32Bit = true; # Active les pilotes 32-bit (Indispensable pour faire tourner les jeux Windows 32-bit via Wine/Proton)
    extraPackages = with pkgs; [
      vkbasalt # Injecte la couche Vulkan vkBasalt pour le post-traitement (filtres visuels / ReShade)
      libva # Support de l'accélération matérielle (décodage/encodage vidéo VA-API)
      mesa.opencl # Fournit le runtime OpenCL (via Rusticl/Mesa) permettant aux logiciels de calcul
      # comme DaVinci Resolve d'exploiter le processeur graphique (GPU)
    ];
  };

  # Active les règles udev et le support matériel pour le matériel Steam
  # (Manettes Steam Controller, HTC Vive / Casques VR, et règles pour manettes Xbox/PlayStation)
  hardware.steam-hardware.enable = true;

  # Configuration de la plateforme Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Ouvre automatiquement les ports du pare-feu pour le streaming Steam Remote Play
    dedicatedServer.openFirewall = true; # Ouvre les ports réseau nécessaires si tu héberges des serveurs de jeu dédiés
    gamescopeSession.enable = true; # Ajoute l'option de lancer une session Steam en mode "Big Picture" gérée par Gamescope (style SteamDeck)
  };

  # Daemon d'optimisation des performances en jeu (GameMode de Feral Interactive)
  programs.gamemode = {
    enable = true;
    enableRenice = true; # Autorise GameMode à modifier la priorité CPU (nice) des processus de jeu
    settings.general = {
      renice = 10; # Augmente la priorité du jeu par rapport aux autres applications d'arrière-plan
      enableWsi = true; # Active l'optimisation des couches d'affichage Vulkan (WSI)
    };
  };

  # Compositeur micro-session dédié au jeu (Gamescope)
  programs.gamescope = {
    enable = true;
    capSysNice = false; # Désactive l'attribution de la capacité CAP_SYS_NICE via les SUID wrappers (géré plus proprement via Gamemode/renice)
  };

  # Daemon de priorités processus CachyOS (Ananicy)
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # Service de démarrage pour l'ordonnanceur personnalisé sched_ext (LAVD)
  # LAVD (Latency-Critical Architecture-Aware Virtual Deadline) optimise l'ordonnancement CPU
  # en réduisant la latence et en tirant parti de l'architecture du processeur (idéal pour le gaming).
  systemd.services.scx = {
    description = "sched_ext LAVD scheduler"; # Description lisible du service dans systemctl
    wantedBy = [ "multi-user.target" ]; # Lance le service automatiquement au démarrage en mode multi-utilisateur (démarrage normal)

    serviceConfig = {
      # Exécute l'ordonnanceur scx_lavd à partir du paquet scx.full
      ExecStart = "${pkgs.scx.full}/bin/scx_lavd";
      # Redémarre automatiquement le service s'il s'arrête ou plante en cours de route
      Restart = "always";
    };
  };

  # =======================================================================
  # 📦 PAQUETS SYSTÈME (environment.systemPackages)
  # =======================================================================
  environment.systemPackages = with pkgs; [
    # 🎮 Jeux & Compatibilité Windows
    umu-launcher # Lanceur unifié pour exécuter Proton/Wine sur des jeux non-Steam
    wine64 # Couche de compatibilité pour exécuter des applications Windows (64 bits)
    winetricks # Assistant pour installer des DLL et composants Windows manquants dans Wine
    protontricks # Assistant pour gérer les composants et réglages dans les préfixes Proton
    steam-run # Exécute des binaires Linux standards non prévus pour l'environnement NixOS
    vkbasalt # Couche de post-traitement Vulkan (filtres visuels/ReShade en jeu)
    low-latency-layer # ⚠️ Provenant du Flake/module Chaotic-Nyx (Couche Vulkan pour réduire la latence)
    innoextract # Extrait le contenu des installeurs Windows Inno Setup (jeux GOG, etc.)

    # 🖥️ Interface & Rendu
    adw-gtk3 # Thème pour uniformiser le style des anciennes apps GTK3 avec Libadwaita
    libadwaita # Bibliothèque de composants graphiques pour les applications GNOME modernes
    libdisplay-info_0_2 # Bibliothèque bas niveau pour la lecture des informations écran (EDID)
    libappindicator-gtk3 # Requis pour les icônes de la zone de notification (systray) des AppImages/apps (ex: Harbor, Discord)
    svp # Application et plugin de fluidification vidéo en temps réel (interpolation de FPS vers 60/144Hz)

    # 📦 Compression & Archives
    atool # Interface en ligne de commande universelle pour gérer tout type d'archive
    gnutar # Outil d'archivage standard (commande tar)
    libarchive # Bibliothèque multi-format d'extraction/compression (fournit bsdtar)
    p7zip # Utilitaire pour la gestion des fichiers compressés .7z
    unrar # Utilitaire pour l'extraction des fichiers compressés .rar
    unzip # Utilitaire pour la décompression des fichiers .zip
    
    # Polices d'ecritre
    font-awesome
    font-awesome_4
    noto-fonts

    # 🛠️ Outils Système
    nh # ⚠️ Outil issu d'un Flake communautaire (Requiert une config NixOS basée sur les Flakes)
    scx.full # Suite d'ordonnanceurs CPU sched_ext (comprend notamment scx_lavd)
    fuse3 # Système de fichiers FUSE v3 (indispensable pour l'exécution des AppImages)
    python3 # Interpréteur Python 3 (dépendance requise pour de nombreux scripts)
    curl # Outil de transfert de données et de requêtes réseau en ligne de commande
    wget # Outil de téléchargement de fichiers depuis le Web
    libva-utils # Fournit la commande 'vainfo' pour vérifier l'encodage matériel
    libxcb # GUI support pour les AppImages/Tkinter (X11 bindings)
    killall 
    # --- Outils ALSA (CLI) ---
    alsa-utils # Fournit alsamixer, aplay, amixer, alsactl (indispensables)
    alsa-tools # Outils avancés pour certaines cartes (hda-jack-retask, etc.)
    alsa-firmware
    alsa-lib # Bibliothèque ALSA (indispensable pour les applications audio)

  ];

  # =======================================================================
  # 🐳 SERVICES & CONTENEURS
  # =======================================================================
  # Support AppImage
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.icu
      pkgs.libxcrypt-legacy
      pkgs.python312
      pkgs.python312Packages.torch
    ];
  };

  # Couche de compatibilité nix-ld
  # Permet d'exécuter directement des binaires Linux pré-compilés non prévus pour NixOS
  # (outils téléchargés hors Nixpkgs, scripts Node/VSCode, exécutables dynamiques) sans erreur d'interpréteur ELF.
  programs.nix-ld = {
    enable = true;
    # Bibliothèques système partagées chargées par défaut dans l'environnement nix-ld
    libraries = with pkgs; [
      stdenv.cc.cc # Bibliothèques d'exécution standard du compilateur C/C++ (libstdc++)
      zlib # Bibliothèque de compression de données standard
      icu # Composant de prise en charge d'Unicode et de l'internationalisation
      nss # Network Security Services (sécurité, certificats SSL/TLS)
      openssl # Bibliothèque de chiffrement et de communication sécurisée
      glib # Bibliothèque bas niveau de structures de données pour le C (utilisée par GNOME/GTK)
    ];
  };

  # Studio d'enregistrement et de streaming vidéo (OBS Studio)
  programs.obs-studio = {
    enable = true;

    # Surcharge d'OBS pour forcer FFmpeg complet (nécessaire pour l'encodage matériel AV1 / VA-API)
    package = pkgs.obs-studio.override {
      ffmpeg = pkgs.ffmpeg-full;
    };

    # Plugins OBS intégrés déclarativement
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs # Capture d'écran native optimisée pour Wayland / wlroots
      obs-backgroundremoval # Filtre de suppression d'arrière-plan sans fond vert (via IA/ML)
      obs-pipewire-audio-capture # Capture audio applicative ultra-précise basée sur PipeWire
      obs-gstreamer # Extension du support d'encodage/décodage via les pipelines GStreamer
      obs-vkcapture # Capture d'écran et de fenêtres de jeu Vulkan/OpenGL à très faible latence
      # (Note: obs-vaapi a été retiré car obsolète et inutile ; le VA-API AV1/H264 est géré nativement via FFmpeg)
    ];
  };

  # Flatpak
  services.flatpak = {
    enable = true;
    update.auto.enable = true;
    update.onActivation = true;
    packages = [
      "org.signal.Signal"
      "com.github.tchx84.Flatseal"
      # "dev.vencord.Vesktop"
      "rocks.shy.VacuumTube"
      "it.mijorus.gearlever"
    ];
  };

  # Virtualisation
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";

  # Services Matériels / Réseau
  services.openssh.enable = true;
  services.lact.enable = true; # AMD Overclocking / Fan control

  # Mise à jour système au démarrage (1 min après boot)
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
  };

  systemd.timers."nixos-upgrade" = {
    timerConfig = {
      OnBootSec = "1min";
      OnCalendar = "";
    };
  };

  # =======================================================================
  # ⚠️ NE PAS MODIFIER
  # =======================================================================
  system.stateVersion = "26.05";
}
