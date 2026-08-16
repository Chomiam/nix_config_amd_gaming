{ vars, ... }:

{
  # =========================================================================
  # 🎛️ SECTEUR HARDWARE : CHARGEMENT DYNAMIQUE DU PROFIL GPU
  # =========================================================================
  imports = [
    (if vars.gpuDriver == "amd" then ./amd.nix
     else if vars.gpuDriver == "nvidia" then ./nvidia.nix
     else if vars.gpuDriver == "nvidia-legacy" then ./nvidia-legacy.nix
     else if vars.gpuDriver == "intel" then ./intel.nix
     else ./amd.nix)
  ];
}
