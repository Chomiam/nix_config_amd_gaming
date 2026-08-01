{ config, pkgs, ... }:

{
  # Création automatique du dossier de montage s'il n'existe pas
  systemd.tmpfiles.rules = [
    "d /mnt/Games 0775 chomiam users -"
  ];

  # Configuration du montage BTRFS
  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/5e42df83-3aff-45c8-a8e6-b25e07ba0130";
    fsType = "btrfs";
    options = [
      "defaults"
      "nofail" # Évite d'être bloqué au boot si le disque a un souci
      "compress=zstd" # Option recommandée pour Btrfs (économise de l'espace sur les jeux)
    ];
  };
}
