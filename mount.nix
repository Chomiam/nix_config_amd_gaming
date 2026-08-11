{ config, pkgs, ... }:

{
  # Règle 'z' pour modifier les permissions du point de montage une fois actif
  systemd.tmpfiles.rules = [
    "z /mnt/Games 0775 chomiam users -"
  ];

  # Configuration du montage BTRFS
  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/5e42df83-3aff-45c8-a8e6-b25e07ba0130";
    fsType = "btrfs";
    options = [
      "defaults"
      "nofail"
      "compress=zstd"
    ];
  };

  # Forcer tmpfiles à s'exécuter après le montage de la partition
  systemd.services.systemd-tmpfiles-setup.after = [ "mnt-Games.mount" ];
}
