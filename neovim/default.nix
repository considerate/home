neovim:
{ pkgs, ... }:
let
  np = pkgs.vimPlugins;
  nvim-repl = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "nvim-repl";
    version = "2022-03-20";
    src = pkgs.fetchFromGitHub {
      owner = "pappasam";
      repo = "nvim-repl";
      rev = "1064eb2191a28eb8fc9a142619d3844b97fd8a75";
      sha256 = "sha256-kFd54ITyfx9pfHPOnSswZKleoGKhMCKyT/rgzQ6DQrU=";
    };
  };
in
{
  imports = [ ./vim-init.nix ];

  xdg.configFile."nvim/coc-settings.json".text = builtins.readFile ./coc-settings.json;

  home.packages = [
    # for coc
    pkgs.nodejs

    # formatters
    pkgs.nixpkgs-fmt
    pkgs.haskellPackages.cabal-fmt
    pkgs.shfmt
    pkgs.uncrustify
    pkgs.clang-tools

    # Fuzzy file find
    pkgs.fzf
  ];

  programs.neovim = {
    enable = true;
    package = neovim.packages.${pkgs.system}.neovim;
    vimAlias = false;
    viAlias = false;
    init = {
      enable = true;
      preConfig = ''
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
      '';

      plugins =
        [
          np.sleuth
          np.surround
          np.commentary
          np.vim-polyglot
          np.vim-repeat
          np.vim-unimpaired
          np.vim-eunuch
          np.vim-easy-align
          np.vim-easymotion
        ];
      modules = gh: {

        repl = {
          plugins = [ nvim-repl ];
          config = ''
            nnoremap <leader>r :ReplToggle<CR>
            nmap <leader>e <Plug>ReplSendLine
            vmap <leader>e <Plug>ReplSendVisual
          '';
        };

        colors = {
          plugins = [ np.base16-vim ];
          config = ''
            set termguicolors
            colorscheme base16-ocean
            set background=dark
          '';
        };
        wild = {
          config = ''
            " show a navigable menu for tab completion
            set wildmenu
            set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
            set wildmode=longest,list,full
            set path+=./**
          '';
        };
        markdown = {
          config = ''
            au BufNewFile,BufRead *.md  set spell
          '';
        };

        netrw = {
          config = ''
            let g:netrw_banner = 0
            let g:netrw_liststyle = 3
            let g:netrw_browse_split = 4
            let g:netrw_altv = 1
            let g:netrw_winsize = 25
            autocmd FileType netrw nnoremap ? :help netrw-quickmap<CR>
          '';
        };

        unicode = { config = "source ${./unicode.vim}"; };

        airline = {
          plugins = [ np.vim-airline np.vim-airline-themes ];
          config = ''
            let g:airline_powerline_fonts = 1
            let g:airline_theme='base16_ocean'
          '';
        };

        sharedClipboard = {
          config = ''
            vmap <leader>y :w! /tmp/vitmp<CR>
            nmap <leader>p :r! cat /tmp/vitmp<CR>
          '';
        };

        escapeKeys = {
          config = ''
            inoremap jj <esc>
          '' +
          # Add shortcut to set hj to escape
          ''
            nn <leader>hj :inoremap hj <esc><CR>
          '';
        };

        git = {
          plugins = [ np.fugitive np.vim-gitgutter ];
          config = ''
            nn <leader>gs :Gstatus<CR>
            nn <leader>ga :GitGutterStageHunk<CR>
            nn <leader>gp :GitGutterPreviewHunk<CR>
            nn <leader>gu :GitGutterUndoHunk<CR>
            set diffopt+=vertical
          '';
        };

        fzf = {
          plugins = [ np.fzf-vim ];
          config = ''
            nn <leader>ff :Files<CR>
            nn <leader>fg :Ag<CR>
            nn <leader>ft :Tags<CR>
            nn <leader>fh :Helptags<CR>
            autocmd FileType haskell let g:fzf_tags_command = 'fast-tags -R'
            au BufWritePost *.hs silent! !${pkgs.haskellPackages.fast-tags}/bin/fast-tags -R . &
            let $FZF_DEFAULT_COMMAND = '${pkgs.silver-searcher}/bin/ag -g ""'
          '';
        };

        neoformat = {
          plugins = [ np.neoformat ];
          packages = [
            pkgs.nixpkgs-fmt
            pkgs.haskellPackages.cabal-fmt
            pkgs.shfmt
            pkgs.uncrustify
            pkgs.clang-tools
          ];
          config = ''
            let g:neoformat_basic_format_trim = 1
            augroup fmt
              autocmd!
              autocmd BufWritePre * silent Neoformat
            augroup END
            let g:neoformat_enabled_haskell = ['ormolu']
          '';
        };

        nerdtree = {
          plugins = [ np.nerdtree ];
          config = ''
            nnoremap <silent> ,f :NERDTreeFind<CR>
            nnoremap <silent> ,d :NERDTreeToggle<CR>
          '';
        };

        coc = {
          enable = true;
          plugins = [ np.coc-nvim ];
          config = ''
            set hidden
            set nobackup
            set nowritebackup
            set cmdheight=2
            set updatetime=300
            set shortmess+=c
            nmap <silent> [e <Plug>(coc-diagnostic-prev)
            nmap <silent> ]e <Plug>(coc-diagnostic-next)
            nnoremap <silent> <leader>lh :call CocActionAsync('doHover')<cr>
            nmap <leader>la <Plug>(coc-codeaction)
            nmap <leader>ll <Plug>(coc-codelens-action)
          '';
        };
      };
    };
  };
}
