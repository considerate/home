{ pkgs, config, ... }: {
  programs = {
    rofi = {
      package = pkgs.rofi.override {
        plugins = [ pkgs.rofi-calc ];
      };
      enable = config.considerate.desktop;
      font = "Fira Code Retina 24";
      # padding = 24;
      # borderWidth = 2;
      # separator = "dash";
      # colors = {
      #   window = {
      #     background = "argb:ee343d46";
      #     border = "argb:ff2b303b";
      #     separator = "argb:ff2b303b";
      #   };
      #   rows = {
      #     normal = {
      #       background = "argb:002b303b";
      #       foreground = "#dfe1e8";
      #       backgroundAlt = "argb:002b303b";
      #       highlight = {
      #         background = "argb:002b303b";
      #         foreground = "#bf616a";
      #       };
      #     };
      #   };
      # };
      extraConfig = {
        display-combi = "Go";
        modi = "combi,calc";
        combi-modi = "window,run,ssh";
      };
      terminal = "${pkgs.kitty}/bin/kitty";
    };
  };
}
