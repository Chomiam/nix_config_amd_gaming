{ pkgs, ... }:

{
  # =========================================================================
  # 📹 OBS STUDIO & PLUGINS STREAMING / CAPTURE
  # =========================================================================

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  };
}
