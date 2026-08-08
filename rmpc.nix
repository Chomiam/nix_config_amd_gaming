{ pkgs, config, ... }:

{
  # 1. Paquets TUI & Outils complémentaires
  home.packages = with pkgs; [
    rmpc         # Client MPD moderne
    mpc          # Outils CLI pour scripts / raccourcis Hyprland
    cava         # Visualiseur audio
    songrec      # Shazam CLI pour identifier les morceaux
    yt-dlp       # Pour télécharger/extraire de l'audio si besoin
  ];

  # 2. Configuration du démon MPD (Home Manager)
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    
    # Sortie PipeWire native
    extraConfig = ''
      audio_output {
        type        "pipewire"
        name        "PipeWire Sound Server"
      }

      # FIFO nécessaire si tu souhaites envoyer l'audio à CAVA
      audio_output {
        type        "fifo"
        name        "Visualizer feed"
        path        "/tmp/mpd.fifo"
        format      "44100:16:2"
      }
    '';
  };

  # 3. Pont MPRIS2 (Indispensable pour intégration Waybar/Notifications/Média)
  services.mpdris2 = {
    enable = true;
    notifications = true; # Notifications bureau lors du changement de morceau
  };

  # 4. Configuration de rmpc (Pochettes Kitty & Disposition)
  xdg.configFile."rmpc/config.ron".text = ''
    (
      address: "127.0.0.1:6600",
      album_art: (
        method: Kitty, # Utilise le protocole Kitty (comme Yazi)
        max_size_px: (width: 600, height: 600),
      ),
      theme: None,
    )
  '';
}
