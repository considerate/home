inputs: { pkgs, lib, config, ... }:
let
  np = pkgs.vimPlugins;

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

  configs = [
    ''
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
      let mapleader = "\<Space>"
      let maplocalleader = "\<Space>"
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
    ''
    ''
      " show a navigable menu for tab completion
      set wildmenu
      set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
      set wildmode=longest,list,full
      set path+=./**
    ''
    # markdown
    ''
      au BufNewFile,BufRead *.md  set spell
    ''

    # netrw
    ''
      let g:netrw_banner = 0
      let g:netrw_liststyle = 3
      let g:netrw_browse_split = 4
      let g:netrw_altv = 1
      let g:netrw_winsize = 25
      autocmd FileType netrw nnoremap ? :help netrw-quickmap<CR>
    ''

    # escapeKeys
    # Add shortcut to set jj to escape
    ''
      inoremap jj <esc>
      nn <leader>hj :inoremap hj <esc><CR>
    ''
  ];
in
{
  home.packages = [
    # Search
    pkgs.ripgrep
    pkgs.fd
    pkgs.viu
  ];

  imports = [ workspace-symbols ];

  programs.fzf.enable = true;
  programs.neovim = {
    enable = true;
    vimAlias = false;
    viAlias = false;
    extraConfig = lib.concatStringsSep "\n" configs;
    extraPackages = [
      # Nix language server
      pkgs.nil
      # GitHub (Octo)
      pkgs.gh
      # Tree Sitter
      pkgs.tree-sitter
      # tree-sitter compilers
      pkgs.gcc
      pkgs.clang
      # delta in fugitive and fzf
      pkgs.delta
      pkgs.chafa
    ];

    plugins = [
      {
        plugin = np.commentary;
        config = ''
          let mapleader = "\<space>"
          let maplocalleader = "\<space>\<space>"
        '';
      }
      np.sleuth
      np.surround
      np.vim-polyglot
      np.vim-repeat
      np.vim-unimpaired
      np.vim-eunuch
      np.vim-easy-align
      np.vim-easymotion

      # Language Server Protocol
      np.nvim-cmp
      np.cmp-buffer
      np.cmp-nvim-lsp
      np.lsp-status-nvim
      np.lsp_signature-nvim
      np.lsp_lines-nvim
      {
        plugin = np.nvim-lspconfig;
        config = ''
          " set completeopt=menu,menuone,noselect
          :luafile ${./lsp.lua}
        '';
      }
      np.nvim-treesitter.withAllGrammars
      np.nvim-treesitter-context
      {
        plugin = np.neotest;
        config = ''
          luafile ${./neotest.lua}
        '';
      }
      np.neotest-haskell
      {
        plugin = np.formatter-nvim;
        config = import ./formatters.nix { inherit pkgs lib; };
      }

      # Octo (GitHub)
      {
        plugin = np.telescope-nvim;
        config = ''
          nn <leader>ff :Telescope git_files<CR>
          nn <leader>ff :Telescope find_files<CR>
          nn <leader>fb :Telescope buffers<CR>
          nn <leader>fg :Telescope live_grep<CR>
          luafile ${./telescope.lua}
        '';
      }
      np.telescope-ui-select-nvim
      np.popup-nvim
      np.telescope-media-files-nvim
      np.nvim-web-devicons
      {
        plugin = np.trouble-nvim;
        config = ''
          luafile ${./trouble.lua}
        '';
      }
      # REPL
      {
        plugin = np.iron-nvim;
        config = ''
          luafile ${./repl.lua}
        '';
      }
      {
        plugin = np.octo-nvim;
        config = ''
          lua << EOF
          require("octo").setup()
          EOF
        '';
      }


      # Colors
      {
        plugin = np.nvim-base16;
        config = ''
          set termguicolors
          set background=dark
          colorscheme base16-ocean
        '';
      }
      np.nvim-dap
      {
        plugin = np.lualine-nvim;
        config = ''
          require('lualine').setup()
        '';
        type = "lua";
      }
      # Git
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
    ];
  };
}
