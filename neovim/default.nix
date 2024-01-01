{ pkgs, lib, config, ... }:
let

  np = pkgs.vimPlugins;

  lsp = {
    programs.neovim.plugins = [
      np.lsp-zero-nvim
      np.nvim-lspconfig
      np.nvim-cmp
      np.cmp-nvim-lsp
      np.cmp-buffer
      np.luasnip
      np.cmp_luasnip
      np.vim-snippets
    ];
    programs.neovim.extraLuaConfig = ''
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({buffer = bufnr})
        -- 2023-12-31: Disable LSP syntax highlighting, treesitter seems better
        client.server_capabilities.semanticTokensProvider = nil
      end)
      local lspconfig = require('lspconfig')

      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()
      cmp.setup({
        sources = {
          {name = 'path'},
          {name = 'nvim_lsp'},
          {name = 'luasnip', keyword_length = 2},
          {name = 'buffer', keyword_length = 3},
        },
        mapping = cmp.mapping.preset.insert({
          -- Navigate between snippet placeholder
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
          -- Scroll up and down in the completion documentation
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
        })
      })

      local luasnip = require('luasnip')
      local from_snipmate = require("luasnip.loaders.from_snipmate")
      from_snipmate.lazy_load()

      ${config.programs.neovim.extraLspConfig}
    '';
  };

  treesitter = {
    programs.neovim.plugins = [
      np.nvim-treesitter-context
      {
        plugin = np.nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
            highlight = { enable = true },
            refactor = {
              highlight_definitions = {
                enable = true,
                clear_on_cursor_move = true,
              },
            },
          }
        '';
      }
    ];
  };

  telescope.programs.neovim = {
    extraPackages = [ pkgs.ripgrep ];
    plugins = [
      np.nvim-web-devicons
      np.telescope-ui-select-nvim
      np.popup-nvim
      np.telescope-media-files-nvim
      {
        plugin = np.telescope-nvim;
        type = "lua";
        config = ''
          require("telescope").load_extension("ui-select")
          require('telescope').load_extension('media_files')
          local telescope = require("telescope.builtin")
          require"telescope".setup {
              defaults = {
                  vimgrep_arguments = {
                      "rg", "-L", "--color=never", "--no-heading", "--with-filename",
                      "--line-number", "--column", "--smart-case"
                  },
                  prompt_prefix = "   ",
                  selection_caret = "  ",
                  entry_prefix = "  ",
                  initial_mode = "insert",
                  selection_strategy = "reset",
                  sorting_strategy = "ascending",
                  layout_strategy = "horizontal",
                  layout_config = {
                      horizontal = {
                          prompt_position = "top",
                          preview_width = 0.55,
                          results_width = 0.8
                      },
                      vertical = {mirror = false},
                      width = 0.87,
                      height = 0.80,
                      preview_cutoff = 120
                  },
                  file_sorter = require("telescope.sorters").get_fuzzy_file,
                  file_ignore_patterns = {"node_modules"},
                  generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                  path_display = {"truncate"},
                  winblend = 0,
                  border = {},
                  borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
                  color_devicons = true,
                  set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
                  file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                  grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                  qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                  -- Developer configurations: Not meant for general override
                  buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
                  mappings = {
                      n = {
                          ["q"] = require("telescope.actions").close,
                      },
                  }
              },

              extensions_list = {"themes", "terms", "fzf"},
              extensions = {
                  fzf = {
                      fuzzy = true,
                      override_generic_sorter = true,
                      override_file_sorter = true,
                      case_mode = "smart_case"
                  }
              }
          }
          vim.keymap.set('n', '<leader>ff', telescope.find_files)
          vim.keymap.set('n', '<leader>fg', telescope.live_grep)
          vim.keymap.set('n', '<leader>fb', telescope.buffers)
          vim.keymap.set('n', '<leader>lq', telescope.diagnostics)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {desc = "Go to declaration"})
          vim.keymap.set('n', 'gd', telescope.lsp_definitions, {desc = "Go to definition"})
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, {desc = "Hover"})
          vim.keymap.set('n', 'gi', telescope.lsp_implementations, {desc = "Show implementation"})
          vim.keymap.set('n', 'gr', telescope.lsp_references, {desc = "Go to reference(s)"})
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {desc = "Signature help"})
          vim.keymap.set('n', '<space>ld', telescope.lsp_type_definitions, {desc = "Show type definition"})
          vim.keymap.set('n', '<space>la', vim.lsp.buf.code_action, {desc = "Run code action"})
          vim.keymap.set('n', '<space>lf', telescope.lsp_references, {desc = "Go to references"})
          -- vim.keymap.set('n', '<space>ls', lsp_sig.toggle_float_win, {desc = "Toggle floating type signature"})
          vim.keymap.set('n', '<space>ln', vim.lsp.buf.rename, {desc = "Rename symbol"})
        '';
      }
    ];
  };

  git.programs.neovim.plugins = [
    {
      plugin = np.fugitive;
      config = ''
        nn <leader>gs :Gstatus<CR>
      '' +
      # Get diff from left and right buffers in Gvdiffsplit
      ''
        xnoremap dh :diffget//2<CR>
        xnoremap dl :diffget//3<CR>
      '';
    }
    {
      plugin = np.vim-gitgutter;
      config = ''
        nn <leader>ga :GitGutterStageHunk<CR>
        nn <leader>gp :GitGutterPreviewHunk<CR>
        nn <leader>gu :GitGutterUndoHunk<CR>
        set diffopt+=vertical
      '';
    }
  ];

  formatters = {
    programs.neovim.plugins = [{
      plugin = np.formatter-nvim;
      # https://github.com/mhartington/formatter.nvim/tree/master/lua/formatter/filetypes
      config =
        let
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
              ${lib.concatStringsSep "\n" (lib.mapAttrsToList mkFmt config.programs.neovim.formatters)}
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
        '';
    }];
  };

  lang-haskell.programs.neovim = {
    plugins = [ np.nvim-treesitter-parsers.haskell ];
    formatters = {
      haskell = { exe = "ormolu"; args = [ "--no-cabal" ]; };
      cabal.exe = "${pkgs.haskellPackages.cabal-fmt.bin}/bin/cabal-fmt";
    };
    extraLspConfig = ''
      lspconfig.hls.setup({})
    '';
  };

  lang-nix.programs.neovim = {
    extraPackages = [ pkgs.nil ];
    plugins = [ np.nvim-treesitter-parsers.nix ];
    formatters.nix.exe = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
    extraLspConfig = ''
      lspconfig.nil_ls.setup({})
    '';
  };

  lang-bash.programs.neovim = {
    extraPackages = [
      pkgs.shellcheck
      pkgs.nodePackages.bash-language-server
    ];
    plugins = [ np.nvim-treesitter-parsers.bash ];
    formatters.sh.exe = "${pkgs.shfmt}/bin/shfmt";
    extraLspConfig = ''
      lspconfig.bashls.setup({})
    '';
  };

  lang-python.programs.neovim = {
    plugins = [ np.nvim-treesitter-parsers.python ];
    formatters.python = { exe = "${pkgs.black}/bin/black"; args = [ "-q" "-" ]; };
    extraLspConfig = ''
      lspconfig.pyright.setup({})
      lspconfig.ruff_lsp.setup({})
    '';
  };

  lang-rust.programs.neovim = {
    plugins = [ np.nvim-treesitter-parsers.rust ];
    formatters.rust = { exe = "rustfmt"; };
    extraLspConfig = ''
      lspconfig.rust_analyzer.setup({
        settings = {["rust-analyzer"] = { checkOnSave = {command="clippy"}}}
      })
    '';
  };

  repl.programs.neovim.plugins = [
    {
      plugin = np.iron-nvim;
      type = "lua";
      config = ''
        local iron = require("iron.core")

        iron.setup {
            config = {
                -- Whether a repl should be discarded or not
                scratch_repl = true,
                -- Your repl definitions come here
                repl_definition = {
                    sh = {
                        -- Can be a table or a function that
                        -- returns a table (see below)
                        command = {"bash"}
                    },
                    haskell = {
                        command = function(meta)
                            local filename = vim.api.nvim_buf_get_name(meta.current_bufnr)
                            return {'cabal', 'v2-repl', filename}
                        end
                    }
                },
                -- How the repl window will be displayed
                -- See below for more information
                repl_open_cmd = require('iron.view').right(60)
            },
            -- Iron doesn't set keymaps by default anymore.
            -- You can set them here or manually add keymaps to the functions in iron.core
            keymaps = {
                send_motion = "<space>sc",
                visual_send = "<space>sc",
                send_file = "<space>sf",
                send_line = "<space>sl",
                send_until_cursor = "<space>su",
                send_mark = "<space>sm",
                mark_motion = "<space>mc",
                mark_visual = "<space>mc",
                remove_mark = "<space>md",
                cr = "<space>s<cr>",
                interrupt = "<space>s<space>",
                exit = "<space>sq",
                clear = "<space>cl"
            },
            -- If the highlight is on, you can change how it looks
            -- For the available options, check nvim_set_hl
            highlight = {italic = true},
            ignore_blank_lines = true -- ignore blank lines when sending visual select lines
        }

        -- iron also has a list of commands, see :h iron-commands for all available commands
        vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
        vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
        vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
        vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
      '';
    }
  ];

  debugging.programs.neovim.plugins = [
    np.nvim-dap
  ];

  workspace-symbols = {
    programs.neovim.extraPackages = [
      # fzf syntax highlighting
      pkgs.bat
    ];

    programs.neovim.plugins = [
      np.plenary-nvim
      {
        plugin = np.fzf-lsp-nvim;
        # NOTE can't use <leader>, not yet bound
        config = ''
          nn <space>fw :WorkspaceSymbols<CR>
        '';
      }
    ];
  };

in
{
  imports = [
    ./options.nix
    lsp
    formatters
    treesitter
    lang-nix
    lang-haskell
    lang-rust
    lang-bash
    lang-python
    repl
    git
    telescope
    debugging
    workspace-symbols
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      set encoding=utf-8
      set autoindent
      set autoread
      set backspace=2
      set backupcopy=yes
      set directory-=.
      set expandtab
      set ignorecase
      set incsearch
      set inccommand=nosplit
      set list
      set listchars=tab:▸\ ,trail:▫
      set number
      set ruler
      set showcmd
      set smartcase
      set shiftwidth=2
      set softtabstop=2
      set tabstop=2
      let mapleader = "\<space>"
      let maplocalleader = "\<space>\<space>"
      set exrc

      set foldmethod=indent
      set foldcolumn=0
      set foldlevel=999

      nn <leader>w :w<CR>
      nn <leader>lo :lopen<CR>
      nn <leader>hl :nohl<CR>

      nn j gj
      nn k gk

      vn j gj
      vn k gk
      vn > >gv
      vn < <gv

      " show a navigable menu for tab completion
      set wildmenu
      set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
      set wildmode=longest,list,full
      set path+=./**

      " escape
      inoremap jj <esc>
      nn <leader>hj :inoremap hj <esc><CR>
    '';
    plugins = [
      # Colors
      {
        plugin = np.nvim-base16;
        config = ''
          set termguicolors
          set background=dark
          colorscheme base16-ocean
        '';
      }
      {
        plugin = np.nerdtree;
        config = ''
          nnoremap <silent> ,f :NERDTreeFind<CR>
          nnoremap <silent> ,d :NERDTreeToggle<CR>
        '';
      }
      {
        plugin = np.fzf-vim;
        config = ''
          nn <leader>ft :Tags<CR>
          nn <leader>fh :Helptags<CR>
          autocmd FileType haskell let g:fzf_tags_command = 'fast-tags -R --exclude=dist-newstye .'
          au BufWritePost *.hs silent! !${pkgs.haskellPackages.fast-tags}/bin/fast-tags -R --exclude=dist-newstyle . &
          let $FZF_DEFAULT_COMMAND = 'ag -g ""'
        '';
      }
      {
        plugin = np.which-key-nvim;
        config = ''
          require("which-key").setup()
        '';
        type = "lua";
      }
      {
        plugin = np.lualine-nvim;
        config = ''
          require('lualine').setup()
        '';
        type = "lua";
      }
    ];
  };
}
