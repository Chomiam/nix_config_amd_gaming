{ pkgs, ... }:

{
  # =========================================================================
  # ⚡ OPTIMISATIONS NOYAU & ZRAM (PERFORMANCES GAMING & LATENCE RÈDUITE)
  # =========================================================================

  # Activation du SWAP ZRAM en RAM
  zramSwap.enable = true;

  # Réglages fins du système pour le jeu à faible latence (SteamOS / Proton tuning)
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;    # Nécessaire pour les gros jeux sous Proton / Wine
    "vm.vfs_cache_pressure" = 100;
    "vm.swappiness" = 180;               # Utilisation prioritaire et agressive de la ZRAM
    "vm.page-cluster" = 0;               # Latence d'E/S ultra-réduite pour ZRAM
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "kernel.split_lock_mitigate" = 0;   # Désactive la réduction de fréquence CPU sur split locks (supprime les micro-saccades)
  };
}
