{ pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      gaps = {
        outer = 20;
        inner = 50;
        # smartGaps = true;
        smartBorders = "on";
      };
      # menu = "${pkgs.wofi}/bin/wofi";
      output = {
        "eDP-1" = {
          resolution = "3840x2160";
          scale = "2";
          background =
            let
              wallpaper = ../wallpaper/wallpapers/DROTTNINGHOLM.jpg;
            in
            if builtins.pathExists wallpaper
            then "${wallpaper} fill"
            else pkgs.nixos-artwork.wallpapers.simple-dark-gray.kdeFilePath;
        };
      };
      input = {
        "*" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };
      seat = {
        seat0 = {
          xcursor_theme = "capitaine-cursors 64";
        };
      };
    };
    extraSessionCommands = ''
      export XCURSOR_PATH=${pkgs.capitaine-cursors}/share/icons:$XCURSOR_PATH
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };
  home.packages = with pkgs; [
    kitty
    swaylock
    swayidle
    wl-clipboard
    mako # notification daemon
    dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance
    breeze-qt5
    breeze-gtk
  ];
}
