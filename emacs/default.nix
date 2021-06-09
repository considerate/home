{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs:
      [
        epkgs.use-package-ensure-system-package
        epkgs.use-package
        epkgs.company
        epkgs.direnv
        epkgs.eglot
        epkgs.haskell-mode
        epkgs.base16-theme
        epkgs.markdown-mode
        epkgs.reformatter
        epkgs.ormolu
      ];
  };

  services.emacs.enable = true;
  home.file.".emacs.d" = { source = ./emacs.d; recursive = true; };

  programs.git = {
    ignores = [
      "*~"
      "\#*\#"
      "/.emacs.desktop"
      "/.emacs.desktop.lock"
      "*.elc"
      "auto-save-list"
      "tramp"
      ".\#*"
      # Org-mode
      ".org-id-locations"
      "*_archive"
      # flymake-mode
      "*_flymake.*"
      # eshell files
      "/eshell/history"
      "/eshell/lastdir"
      # elpa packages
      "/elpa/"
      # reftex files
      "*.rel"
      # AUCTeX auto folder
      "/auto/"
      # cask packages
      # Flycheck
      "flycheck_*.el"
      # server auth directory
      # "/server/"
      # projectiles files
      ".projectile"
      # directory configuration
      ".dir-locals.el"
      # network security
      "/network-security.data"
    ];
  };
}
