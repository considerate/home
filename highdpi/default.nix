{ pkgs, ... }: {
  home.sessionVariables = {
    GTK_PATH = "$GTK_PATH:${pkgs.breeze-gtk}/lib/gtk-3.0";
    GDK_SCALE = 2;
    GDK_DPI_SCALE = "1";
  };
  # xresources.extraConfig = ''
  #   Xft.dpi: 196
  # '';
}
