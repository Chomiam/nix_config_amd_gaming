{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  # =======================================================================
  # 📁 IMPORTS
  # =======================================================================
  imports = [
    ./hardware-configuration.nix
    # ./stylix.nix
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
    # Remplacent le DNS par défaut du FAI pour plus de rapidité/confidentialité
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
  # 🔊 AUDIO, IMPRESSION & SERVICES EFFECT
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
      "video"
      "render" # Accès direct au GPU AMD pour ROCm / Ollama / ComfyUI
    ];
    shell = pkgs.fish;

    packages = with pkgs; [

      # 🎮 Gaming & Multimédia
      lutris # Gestionnaire universel de jeux (GOG, Epic, Humble, emulators, etc.)
      heroic # Lanceur alternatif open-source pour Epic Games, GOG et Amazon Prime Games
      eden # Émulateur Nintendo Switch axé sur les hacks mod haute performance
      ludusavi # Outil de sauvegarde automatique des sauvegardes (savegames) de jeux PC
      protonplus # Interface graphique pour télécharger/gérer GE-Proton, Wine-GE et DXVK facilement
      protontricks # Utilitaire pour installer des dépendances Windows dans les préfixes Proton
      mangohud # Overlay en jeu affichant FPS, températures CPU/GPU, utilisation RAM et VRAM
      goverlay # Interface graphique pour configurer MangoHud, vkBasalt et ReplaySorcery
      stremio-linux-shell # Interface Shell/Linux pour le lecteur multimédia et de streaming Stremio
      kodi # Centre multimédia complet pour la gestion de vos médias
      vlc # Lecteur média universel et léger pour tous formats
      easyeffects # Effets audio pour les applications Linux
      mpv # Moteur de rendu multimédia
      inputs.yt-x.packages.${pkgs.stdenv.hostPlatform.system}.default

      # 💼 Productivité & Bureautique
      google-chrome # Navigateur web Google Chrome
      discord # Client de messagerie et de communication en temps réel
      onlyoffice-desktopeditors # Suite bureautique complète (compatible MS Office)
      davinci-resolve # Logiciel de montage vidéo professionnel
      godot # Éditeur de jeux 2D/3D
      thunderbird # Client de messagerie électronique, calendrier et gestionnaire de contacts
      popsicle # Outil simple d'écriture d'images ISO sur plusieurs clés USB en parallèle
      bazaar # Boutique/catalogue d'applications alternatives pour Linux
      zed-editor # Éditeur de code ultra-rapide et moderne écrit en Rust
      nil # Language Server (LSP) pour le langage Nix

      # 🛠️ Outils CLI & Shell
      fzf # Outil de recherche floue (fuzzy finder) ultra-rapide dans le terminal
      grc # Generic Colouriser : ajoute de la couleur aux sorties de commandes
      btop # Moniteur de ressources système interactif (CPU, RAM, Disque, Réseau)
      fastfetch # Outil d'affichage des informations système ultra-rapide
      git # Système de contrôle de version pour la gestion de code
      fishPlugins.done # Plugin Fish : envoie une notification quand une commande longue est terminée
      fishPlugins.fzf-fish # Plugin Fish : intègre les raccourcis de recherche FZF
      fishPlugins.forgit # Plugin Fish : intègre FZF avec Git de manière interactive
      fishPlugins.hydro # Plugin Fish : prompt minimaliste et moderne
      fishPlugins.grc # Plugin Fish : coloration automatique des commandes via GRC

      # 🌐 Réseau et Pare-feu
      tailscale # VPN mesh sécurisé basé sur WireGuard
    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = "set fish_greeting";
  };

#   # =======================================================================
#   # 🤖 INTELLIGENCE ARTIFICIELLE & RECHERCHE LOCAL
#   # =======================================================================
# :  # Ollama exécuté sur le GPU AMD RX 9070 XT via ROCm (RDNA 4)
#   services.ollama = {
#     enable = true;
#     package = pkgs.ollama-rocm;
#     rocmOverrideGfx = "12.0.1";
#     environmentVariables = {
#       HSA_OVERRIDE_GFX_VERSION = "12.0.1";
#       # Libère la VRAM instantanément après chaque génération de prompt
#       OLLAMA_KEEP_ALIVE = "0s";
#     };
#   };
#
#   # SearXNG : Moteur de recherche privé (Sert d'outil d'accès web à l'agent)
#   services.searx = {
#     enable = true;
#     settings = {
#       server = {
#         port = 8888;
#         bind_address = "127.0.0.1";
#         secret_key = "secret_key_chomiam_local_ia";
#       };
#       search = {
#         safe_search = 0;
#         formats = [ "html" "json" ]; # Le format JSON est nécessaire pour l'extraction via Open-WebUI
#       };
#     };
#   };
#
#   # Interface Open-WebUI (Agent d'interaction avec le modèle + Web Search)
#   services.open-webui = {
#     enable = true;
#     port = 8080;
#     environment = {
#       OLLAMA_BASE_URL = "http://127.0.0.1:11434";
#     };
#   };

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
    enable32Bit = true; # Active les pilotes 32-bit (Indispensable pour jeux Windows 32-bit via Wine/Proton)
    extraPackages = with pkgs; [
      vkbasalt # Injecte la couche Vulkan vkBasalt pour le post-traitement (filtres visuels / ReShade)
      libva # Support de l'accélération matérielle (décodage/encodage vidéo VA-API)
      mesa.opencl # Fournit le runtime OpenCL (via Rusticl/Mesa) pour DaVinci Resolve
      rocmPackages.clr # Runtimes ROCm pour le calcul GPU AMD
    ];
  };

  # Active les règles udev et le support matériel pour le matériel Steam
  hardware.steam-hardware.enable = true;

  # Configuration de la plateforme Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Ouvre automatiquement les ports du pare-feu pour Steam Remote Play
    dedicatedServer.openFirewall = true; # Ouvre les ports réseau pour l'hébergement de serveurs dédiés
    gamescopeSession.enable = true; # Session Steam en mode "Big Picture" gérée par Gamescope
  };

  # Démon d'optimisation des performances en jeu (GameMode)
  programs.gamemode = {
    enable = true;
    enableRenice = true; # Autorise GameMode à modifier la priorité CPU (nice)
    settings.general = {
      renice = 10; # Augmente la priorité du jeu par rapport aux applications d'arrière-plan
      enableWsi = true; # Active l'optimisation des couches d'affichage Vulkan (WSI)
    };
  };

  # Compositeur micro-session dédié au jeu (Gamescope)
  programs.gamescope = {
    enable = true;
    capSysNice = false; # Désactive l'attribution de capacité SUID (géré via Gamemode/renice)
  };

  # Démon de priorités processus CachyOS (Ananicy)
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # Service de démarrage pour l'ordonnanceur personnalisé sched_ext (LAVD)
  systemd.services.scx = {
    description = "sched_ext LAVD scheduler";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.scx.full}/bin/scx_lavd";
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
    winetricks # Assistant pour installer des DLL et composants Windows manquants
    protontricks # Assistant pour gérer les composants dans les préprefixes Proton
    steam-run # Exécute des binaires Linux standards non prévus pour NixOS
    vkbasalt # Couche de post-traitement Vulkan (filtres visuels/ReShade en jeu)
    low-latency-layer # Couche Vulkan pour réduire la latence
    innoextract # Extrait le contenu des installeurs Windows Inno Setup

    # 🖥️ Interface & Rendu
    adw-gtk3 # Thème pour uniformiser le style des anciennes apps GTK3 avec Libadwaita
    libadwaita # Composants graphiques pour applications GNOME modernes
    libdisplay-info_0_2 # Lecture des informations écran (EDID)
    libappindicator-gtk3 # Icônes de zone de notification (systray) pour AppImages
    svp # Interpolation vidéo en temps réel vers 60/144Hz

    # 📦 Compression & Archives
    atool # Interface universelle pour gérer tout type d'archive
    gnutar # Outil d'archivage standard (commande tar)
    libarchive # Bibliothèque multi-format d'extraction/compression (bsdtar)
    p7zip # Utilitaire pour la gestion des fichiers compressés .7z
    unrar # Extrait les fichiers compressés .rar
    unzip # Décompresse les fichiers .zip

    # 🔤 Polices d'écriture
    font-awesome
    font-awesome_4
    noto-fonts

    # 🛠️ Outils Système
    nh # CLI d'aide pour la gestion des Flakes NixOS
    scx.full # Ordonnanceurs CPU sched_ext (comprend scx_lavd)
    fuse3 # Système de fichiers FUSE v3 (indispensable pour les AppImages)
    python3 # Interpréteur Python 3
    curl # Transfert de données en ligne de commande
    wget # Téléchargement de fichiers web
    libva-utils # Diagnostic d'encodage/décodage matériel (commandes vainfo)
    libxcb # Support GUI pour AppImages/Tkinter
    killall # Utilitaire d'arrêt de processus par nom

    # 🔊 Outils ALSA (CLI)
    alsa-utils # Outils d'administration audio CLI (alsamixer, amixer, etc.)
    alsa-tools # Outils avancés pour cartes audio matérielles
    alsa-firmware # Firmwares propriétaires pour puces audio
    alsa-lib # Bibliothèque C bas niveau pour l'API ALSA
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

  # Couche de compatibilité nix-ld (Exécution de binaires ELF pré-compilés)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc # Bibliothèques d'exécution standard C/C++
      zlib # Compression
      icu # Composants Unicode
      nss # Certificats et sécurité SSL/TLS
      openssl # Chiffrement
      glib # Structures de données C
    ];
  };

  # Studio d'enregistrement et de streaming vidéo (OBS Studio)
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override {
      ffmpeg = pkgs.ffmpeg-full;
    };
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs # Capture Wayland / wlroots
      obs-backgroundremoval # suppression d'arrière-plan IA
      obs-pipewire-audio-capture # Capture audio applicative PipeWire
      obs-gstreamer # Pipelines GStreamer
      obs-vkcapture # Capture Vulkan/OpenGL à très faible latence
    ];
  };

  # Support Flatpak
  services.flatpak = {
    enable = true;
    update.auto.enable = true;
    update.onActivation = true;
    packages = [
      "org.signal.Signal"
      "com.github.tchx84.Flatseal"
      "rocks.shy.VacuumTube"
      "it.mijorus.gearlever"
    ];
  };

# ===========================================================================
  # 🐳 Virtualisation & Moteur Docker
  # ===========================================================================
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";



  # ===========================================================================
  # 🎨 Conteneur ComfyUI (Image Communautaire Stable ROCm)
  # ===========================================================================
  # virtualisation.oci-containers.containers.comfyui = {
  #   # Image communautaire de référence (PyTorch ROCm stable, pas de version Alpha)
  #   image = "yanwk/comfyui-boot:rocm";
  #
  #   # Exposition de l'interface Web
  #   ports = [ "8188:8188" ];
  #
  #   # NOTE : On n'utilise pas 'cmd = [...]' car le point d'entrée de ce conteneur
  #   # exécute son propre script qui intercepte la variable CLI_ARGS.
  #   environment = {
  #     # Drapeaux d'exécution transmis directement au serveur ComfyUI
  #     CLI_ARGS = "--listen 0.0.0.0 --port 8188 --lowvram";
  #
  #     # Anti-fragmentation de la mémoire VRAM par PyTorch
  #     PYTORCH_CUDA_ALLOC_CONF = "expandable_segments:True";
  #
  #     # Identification de l'architecture GPU (RDNA 4 / RX 9070 XT -> GFX 12.0.1)
  #     HSA_OVERRIDE_GFX_VERSION = "12.0.1";
  #
  #     # Prévention des gels système dus aux accès SDMA sur puces AMD grand public
  #     HSA_ENABLE_SDMA = "0";
  #   };
  #
  #   # Persistance intégrale des données et stockages sur l'hôte NixOS
  #   volumes = [
  #     # Montage des modèles sur le chemin attendu par le conteneur
  #     "/var/lib/comfyui/models:/root/ComfyUI/models"
  #     # Persistance de la configuration utilisateur, des workflows et du cache ComfyUI-Manager
  #     "/var/lib/comfyui/user:/root/ComfyUI/user"
  #     # Persistance des nœuds personnalisés et extensions installées
  #     "/var/lib/comfyui/custom_nodes:/root/ComfyUI/custom_nodes"
  #     # Montage du dossier de sortie des images
  #     "/var/lib/comfyui/output:/root/ComfyUI/output"
  #   ];
  #
  #   # Accès direct aux périphériques matériels AMD (ROCm & DRI)
  #   extraOptions = [
  #     "--device=/dev/kfd"   # Kernel Fusion Driver (Pilote principal ROCm)
  #     "--device=/dev/dri"   # Direct Rendering Infrastructure (Accélération graphique)
  #     "--group-add=video"   # Attribution des privilèges du groupe vidéo hôte
  #     "--ipc=host"          # Partage de mémoire IPC (évite les engorgements VRAM/RAM)
  #     "--net=host"          # Alignement sur le réseau hôte pour accès direct
  #   ];
  # };

  # =======================================================================
  # ⚠️ NE PAS MODIFIER
  # =======================================================================
  system.stateVersion = "26.05";
}
