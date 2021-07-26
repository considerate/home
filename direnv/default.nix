{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.git.ignores = [ ".direnv" ];
  programs = {
    bash = {
      initExtra = ''
        # Make direnv silent
        export DIRENV_LOG_FORMAT=""
      '';
    };
  };
}
