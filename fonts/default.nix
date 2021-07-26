{ pkgs, config, lib, ... }:
let
  defaultFontsConf = cfg:
    let genDefault = fonts: name:
      lib.optionalString (fonts != [ ]) ''
        <alias binding="same">
          <family>${name}</family>
          <prefer>
          ${lib.concatStringsSep ""
          (map (font: ''
            <family>${font}</family>
          '') fonts)}
          </prefer>
        </alias>
      '';
    in
    pkgs.writeTextFile {
      name = "fc-52-nixos-default-fonts.conf";
      destination = "/lib/fontconfig/fc-52-nixos-default-fonts";
      text = ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
        <fontconfig>
          <!-- Default fonts -->
          ${genDefault cfg.defaultFonts.sansSerif "sans-serif"}
          ${genDefault cfg.defaultFonts.serif     "serif"}
          ${genDefault cfg.defaultFonts.monospace "monospace"}
        </fontconfig>
      '';
    };
in
{
  fonts.fontconfig.enable = config.considerate.desktop;
  home.packages = lib.optionals config.considerate.desktop [
    pkgs.fira-code
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk
    pkgs.fontconfig
    (pkgs.nerdfonts.override {
      fonts = [ "FiraCode" "Noto" ];
    })
    (defaultFontsConf {
      defaultFonts = {
        monospace = [ "FiraCode Nerd Font" "Fira Code Retina" "Noto Sans Mono DemiLight" "Noto Mono" ];
        serif = [ "Noto Serif DemiLight" "Noto Serif CJK JP DemiLight" ];
        sansSerif = [ "Liberation Sans" "Noto Sans CJK JP DemiLight" ];
      };
    })
  ];
}
