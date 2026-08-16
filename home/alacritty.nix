{ pkgs, ... }:

{
  # =========================================================================
  # 💻 TERMINAL PRINCIPAL (ALACRITTY)
  # =========================================================================

  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        padding = {
          x = 8;
          y = 8;
        };
        opacity = 0.90;
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = 11;
      };

      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
      };
    };
  };
}
