{ pkgs, ... }:

{
  # =========================================================================
  # 📦 SUPPORT FLATPAK (NIX-FLATPAK)
  # =========================================================================

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
}
