{ lib, pkgs, ... }:
{
  home.file = {
    base16 = {
      source = builtins.fetchGit {
        url = "https://github.com/chriskempson/base16-shell.git";
        rev = "ce8e1e540367ea83cc3e01eec7b2a11783b3f9e1";
      };
      target = ".config/base16-shell";
    };
  };
  gtk = {
    enable = true;
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
  };
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark";
      package = [ pkgs.adwaita-qt pkgs.adwaita-qt6 ];
    };
  };
  xresources.extraConfig = lib.mkBefore ''
    ! Base16 Ocean
    ! Scheme: Chris Kempson (http://chriskempson.com)

    #define base00 #2b303b
    #define base01 #343d46
    #define base02 #4f5b66
    #define base03 #65737e
    #define base04 #a7adba
    #define base05 #c0c5ce
    #define base06 #dfe1e8
    #define base07 #eff1f5
    #define base08 #bf616a
    #define base09 #d08770
    #define base0A #ebcb8b
    #define base0B #a3be8c
    #define base0C #96b5b4
    #define base0D #8fa1b3
    #define base0E #b48ead
    #define base0F #ab7967

    *foreground:   base05
    #ifdef background_opacity
    *background:   [background_opacity]base00
    #else
    *background:   base00
    #endif
    *cursorColor:  base05

    *color0:       base00
    *color1:       base08
    *color2:       base0B
    *color3:       base0A
    *color4:       base0D
    *color5:       base0E
    *color6:       base0C
    *color7:       base05

    *color8:       base03
    *color9:       base08
    *color10:      base0B
    *color11:      base0A
    *color12:      base0D
    *color13:      base0E
    *color14:      base0C
    *color15:      base07

    ! Note: colors beyond 15 might not be loaded (e.g., xterm, urxvt),
    ! use 'shell' template to set these if necessary
    *color16:      base09
    *color17:      base0F
    *color18:      base01
    *color19:      base02
    *color20:      base04
    *color21:      base06
  '';
}
