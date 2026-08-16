{ inputs, vars ? import ./vars.nix, ... }:

{
  # Redirection vers la nouvelle configuration modulaire hôte "desktop"
  imports = [
    ./hosts/desktop/configuration.nix
  ];
}
