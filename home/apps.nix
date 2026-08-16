{ pkgs, ... }:

{
  # =========================================================================
  # 📦 PAQUETS UTILISATEUR & PARAMÈTRES D'ENVIRONNEMENT HOME-MANAGER
  # =========================================================================

  # Polices d'écriture utilisateur
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Traitement Audio (EasyEffects)
  services.easyeffects.enable = true;

  # Variables d'environnement de session
  home.sessionVariables = {
    TERMINAL = "alacritty";
  };

  # Fastfetch Configuration Preset
  xdg.configFile."fastfetch/config.jsonc".source =
    "${pkgs.fastfetch}/share/fastfetch/presets/examples/13.jsonc";
}
