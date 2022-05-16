{ pkgs, config, ... }: {
  programs = {
    rofi = {
      package = pkgs.rofi.override {
        plugins = [ pkgs.rofi-calc ];
      };
      enable = config.considerate.desktop;
      font = "Fira Code Retina 24";
      theme = "base16-ocean";
      extraConfig = {
        display-combi = "Go";
        modi = "combi,calc";
        combi-modi = "window,run,ssh";
      };
      terminal = "${pkgs.kitty}/bin/kitty";
    };
  };
  home.file.".local/share/rofi/themes/base16-ocean.rasi".source = ./base16-ocean.rasi;
}
