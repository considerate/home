{ pkgs, config, ... }:
let
  rofi-launcher = pkgs.writeShellApplication {
    name = "rofi-launcher";
    runtimeInputs = [ ];
    text = builtins.readFile ./bin/launcher;
  };
  rofi-runner = pkgs.writeShellApplication {
    name = "rofi-runner";
    runtimeInputs = [ ];
    text = builtins.readFile ./bin/runner;
  };
  rofi-screenshot = pkgs.writeShellApplication {
    name = "rofi-screenshot";
    runtimeInputs = [ ];
    text = builtins.readFile ./bin/screenshot;
  };
  rofi-powermenu = pkgs.writeShellApplication {
    name = "rofi-powermenu";
    runtimeInputs = [ pkgs.swaylock ];
    text = builtins.readFile ./bin/powermenu;
  };

in
{
  home.packages = [
    rofi-launcher
    rofi-runner
    rofi-screenshot
    rofi-powermenu
  ];
  programs = {
    rofi = {
      package = pkgs.rofi.override {
        plugins = [ pkgs.rofi-calc ];
      };
      enable = config.considerate.desktop;
      font = "Fira Code Retina 24";
      extraConfig = {
        display-combi = "Go";
        modi = "combi,calc";
        combi-modi = "window,run,ssh";
      };
      theme = "launcher";
      terminal = "${pkgs.kitty}/bin/kitty";
    };
  };
  home.file.".local/share/rofi/themes".source = ./themes;
}
