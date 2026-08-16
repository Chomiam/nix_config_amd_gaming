{ vars, ... }:

{
  # =========================================================================
  # 🖥️ SECTEUR DESKTOP : SÉLECTION DYNAMIQUE DE L'ENVIRONNEMENT DE BUREAU
  # =========================================================================
  imports =
    if vars.desktopEnv == "gnome" then [ ./gnome.nix ]
    else if vars.desktopEnv == "cosmic" then [ ./cosmic.nix ]
    else if vars.desktopEnv == "both" then [ ./gnome.nix ./cosmic.nix ]
    else [ ./cosmic.nix ];
}
