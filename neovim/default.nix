inputs: { pkgs, lib, config, ... }:
let
  np = pkgs.vimPlugins;
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
  unp = unstable.vimPlugins;

  workspace-symbols = {
    home.packages = [
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

    # sharedClipboard
    ''
      vmap <leader>y :w! /tmp/vitmp<CR>
      nmap <leader>p :r! cat /tmp/vitmp<CR>
    ''

    # escapeKeys
    # Add shortcut to set hj to escape
    ''
      inoremap jj <esc>
      nn <leader>hj :inoremap hj <esc><CR>
    ''
  ];
in
{
  home.packages = [
    # Nix language server
    pkgs.nil
    # GitHub (Octo)
    pkgs.gh
    # Search
    pkgs.ripgrep
  ];

  imports = [ workspace-symbols ];

  programs.fzf.enable = true;
  programs.neovim = {
    enable = true;
    vimAlias = false;
    viAlias = false;
    extraConfig = lib.concatStringsSep "\n" configs;
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
      np.nvim-treesitter
      unp.lsp-status-nvim
      {
        plugin = unp.nvim-lspconfig;
        config = ''
          " autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
          " set completeopt=menu,menuone,noselect
          :luafile ${./lsp.lua}
        '';
      }

      {
        plugin = unp.formatter-nvim;
        config = import ./formatters.nix { inherit pkgs lib; };
      }

      # Octo (GitHub)
      np.telescope-nvim
      np.nvim-web-devicons
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
        plugin = np.base16-vim;
        config = ''
          set termguicolors
          colorscheme base16-ocean
          set background=dark
        '';
      }
      {
        plugin = np.vim-airline-themes;
        config = ''
          let g:airline_theme='base16_ocean'
        '';
      }
      # Airline
      {
        plugin = np.vim-airline;
        config = ''
          let g:airline_powerline_fonts = 1

          function! LspStatus() abort
            let status = luaeval("require('lsp-status').status()")
            return trim(status)
          endfunction
          call airline#parts#define_function('lsp_status', 'LspStatus')
          call airline#parts#define_condition('lsp_status', 'luaeval("#vim.lsp.buf_get_clients() > 0")')
          let g:airline#extensions#nvimlsp#enabled = 0
          let g:airline_section_warning = airline#section#create_right(['lsp_status'])
        '';
      }
      # Git
      {
        plugin = np.fugitive;
        config = ''
          nn <leader>gs :Gstatus<CR>
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
          nn <leader>ff :GFiles<CR>
          nn <leader>fa :Files<CR>
          nn <leader>fb :Buffers<CR>
          nn <leader>fg :Ag<CR>
          nn <leader>ft :Tags<CR>
          nn <leader>fh :Helptags<CR>
          autocmd FileType haskell let g:fzf_tags_command = 'fast-tags -R --exclude=dist-newstye .'
          au BufWritePost *.hs silent! !${pkgs.haskellPackages.fast-tags}/bin/fast-tags -R --exclude=dist-newstyle . &
          let $FZF_DEFAULT_COMMAND = 'ag -g ""'
        '';
      }
    ];
  };
}
