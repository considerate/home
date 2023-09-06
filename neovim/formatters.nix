{ pkgs, lib }:
let
  formatters = {
    python =
      let
        fixable = [ "E" "F" "I" "W" "ANN" "B" "Q" "COM" "PT" "PYI" "G010" ];
        unfixable = [
          "F841" # don't delete unused variables
          "F401" # don't delete unused import
        ];
      in
      {
        exe = "ruff";
        args = [
          "check"
          "--fix"
          "--quiet"
          "--exit-zero"
          "--fixable"
          (lib.concatStringsSep "," fixable)
          "--unfixable"
          (lib.concatStringsSep "," unfixable)
        ];
        stdin = false;
      };
    haskell = { exe = "ormolu"; stdin = false; args = [ "-i" ]; };
    cabal.exe = "${pkgs.haskellPackages.cabal-fmt}/bin/cabal-fmt";
    nix.exe = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
    go.exe = "gofmt";
    sh.exe = "${pkgs.shfmt}/bin/shfmt";
    proto.exe = "${pkgs.clang-tools}/bin/clang-format";
    lua = {
      exe = "${pkgs.luaformatter}/bin/lua-format";
      stdin = false;
      args = [ "-i" ];
    };
  };
  quote = str: "\"${str}\"";
  mkFmt = ft: { exe, stdin ? true, args ? [ ] }: ''
    ${ft} = {
      function()
        return {
          exe = ${quote exe},
          args = { ${lib.concatMapStringsSep ", " quote args } },
          stdin = ${if stdin then "true" else "false"},
        }
      end
    },
  '';
in
''
  lua << EOF
  local util = require "formatter.util"
  require("formatter").setup {
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList mkFmt formatters)}
      ["*"] = {
        require("formatter.filetypes.any").remove_trailing_whitespace
      },
    },
  }
  EOF
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost * FormatWrite
  augroup END
''
