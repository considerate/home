{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    acpilight
    awscli
    bottom
    vim
    entr
    feh
    htop
    imagemagick
    mplayer
    mutt
    ncdu
    okular
    pandoc
    pavucontrol
    spotify
    tldr
    wget
    xclip
    nix-diff
    git-absorb
    sd
    fd
    ripgrep
  ];

  environment.variables = { EDITOR = "nvim"; };

  services.udev.packages = [ pkgs.acpilight ];
}
