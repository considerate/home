{
  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;
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
