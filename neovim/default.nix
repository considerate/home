{ pkgs, ... }:
let
  np = pkgs.vimPlugins;
in
{
  imports = [ ./vim-init.nix ];

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
    vimAlias = false;
    viAlias = false;
    init = {
      enable = true;
      preConfig = ''
        " always use utf-8
        set encoding=utf-8

        set autoindent
        " reload files when changed on disk, i.e. via `git checkout`
        set autoread
        " Fix broken backspace in some setups
        set backspace=2
        " see :help crontab
        set backupcopy=yes

        " don't store swapfiles in the current directory
        set directory-=.

        " expand tabs to spaces
        set expandtab

        " case-insensitive search
        set ignorecase

        " search as you type
        set incsearch

        " always show statusline
        " set laststatus=4

        " show trailing whitespace
        set list
        set listchars=tab:▸\ ,trail:▫

        " show line numbers
        set number
        " show current line
        set ruler

        " show context above/below cursorline
        " set scrolloff=3

        " show current command in command line
        set showcmd
        " case-sensitive search if any caps
        set smartcase

        " normal mode indentation
        set shiftwidth=2
        " insert mode indentation
        set softtabstop=2
        " actual tabs occupy 2 characters
        set tabstop=2

        " Execute .nvimrc
        set exrc nosecure

        " Use Spacebar as leader
        let mapleader = "\<Space>"
        let maplocalleader = "\<Space>"

        " Enable spellcheck for markdown
        au BufNewFile,BufRead *.md  set spell

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

        colors = {
          plugins = [ np.base16-vim ];
          config = ''
            " set up colors
            set termguicolors
            " let base16colorspace=256
            colorscheme base16-ocean
            set background=dark
          '';
        };
        diffview = {
          plugins = [ np.diffview-nvim ];
        };
        ghcid =
          let
            neovim-ghcid = pkgs.vimUtils.buildVimPlugin {
              name = "ghcid";
              src = builtins.fetchGit
                {
                  url = "https://github.com/ndmitchell/ghcid.git";
                  rev = "abbb157ac9d06fdfba537f97ab96e197b3bb36cb";
                } + "/plugins/nvim";
            };
          in
          {
            plugins = [ neovim-ghcid ];
            config = ''
              let g:ghcid_keep_open = 1
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

        escapeKeys = { config = "inoremap jj <esc>"; };

        pandoc = {
          plugins = [
            np.vim-pandoc
            np.vim-pandoc-syntax
            np.vim-table-mode
          ];
          config = ''
            " Do not use pandoc formatting for all markdown files
            let g:pandoc#filetypes#pandoc_markdown=0
            let g:table_mode_corner_corner='+'
            let g:neoformat_pandoc_pandoctables = {
              \ 'exe': '${pkgs.pandoc}/bin/pandoc',
              \ 'args': [
                  \ '-f' ,
                  \ join(["markdown"], ""),
                  \ '-t',
                  \ join(["markdown"], ""),
                  \ '-s',
                  \ '--columns=120',
                  \ '--markdown-headings=atx',
              \ ],
              \ 'stdin': 1,
              \ }
            let g:neoformat_enabled_pandoc = ['pandoctables']

            let g:pandoc#formatting#formatprg#use_pandoc = 1
            let g:pandoc#formatting#mode = 'h'
            let g:table_mode_corner_corner='+'
            let g:table_mode_header_fillchar='='
            let g:pandoc#formatting#textwidth=120
          '';
        };


        emmet = {
          plugins = [ np.emmet-vim ];
          config = ''
            let g:user_emmet_install_global = 0
            autocmd FileType html,css EmmetInstall
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
          plugins = [ np.fzf-vim np.fzfWrapper ];
          config = ''
            nn <leader>ff :Files<CR>
            nn <leader>fg :Ag<CR>
            nn <leader>ft :Tags<CR>
            nn <leader>fh :Helptags<CR>
            autocmd FileType haskell let g:fzf_tags_command = 'fast-tags -R'
            au BufWritePost *.hs silent! !${pkgs.haskellPackages.fast-tags}/bin/fast-tags -R . &
            let $FZF_DEFAULT_COMMAND = 'ag -g ""'
          '';
        };

        hoogle = {
          enable = false;
          config = ''
            function! HoogleSearch()
             let searchterm = expand("<cword>")
             silent exec "silent !(firefox \"http://localhost:8080/?hoogle=" . searchterm . "\" > /dev/null 2>&1) &"
            endfunction
            autocmd FileType haskell nn K :call HoogleSearch()<CR><C-l>
          '';
        };

        neoformat = {
          plugins = [
            (
              gh "sbdchd/neoformat" {
                rev = "7e458dafae64b7f14f8c2eaecb886b7a85b8f66d";
              }
            )
          ];
          config = ''
            let g:neoformat_basic_format_trim = 1
            augroup fmt
            autocmd!
            autocmd BufWritePre * silent Neoformat
            augroup END
            let g:neoformat_enabled_javascript = []
            let g:neoformat_enabled_typescript = []
            let g:neoformat_enabled_nix = ['nixpkgsfmt']
            nn <leader>fm :Neoformat<CR>
            nn <leader>fo :Neoformat ormolu<CR>
            nn <leader>fs :Neoformat stylishhaskell<CR>
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
          plugins = [ np.coc-nvim np.coc-fzf ];
          config = ''
            set hidden
            set nobackup
            set nowritebackup
            set cmdheight=2
            set updatetime=300
            nmap <leader>f <Plug>(coc-codeaction)
            nmap <leader>lf :<C-u>CocFzfList diagnostics<cr>
            nmap <leader>la :CocFzfList actions<cr>
            nmap <leader>h f_v<Plug>(coc-codeaction-selected)<C-C>
            nmap <leader>ll <Plug>(coc-codelens-action)
            nmap <leader>ld <Plug>(coc-definition)
            nmap <leader>ly <Plug>(coc-type-definition)
            nmap <leader>li <Plug>(coc-implementation)
            nmap <leader>lr <Plug>(coc-references)
            nmap <leader>lh :call <SID>show_documentation()<CR>
            nmap <silent> [w <Plug>(coc-diagnostic-prev)
            nmap <silent> ]w <Plug>(coc-diagnostic-next)
            nmap <silent> [e <Plug>(coc-diagnostic-prev)
            nmap <silent> ]e <Plug>(coc-diagnostic-next)
            command! -nargs=0 Format :call CocAction('format')
            function! s:show_documentation()
              if (index(['vim','help'], &filetype) >= 0)
                execute 'h '.expand('<cword>')
              else
                call CocAction('doHover')
              endif
            endfunction
            " Highlight the symbol and its references when holding the cursor.
            autocmd CursorHold * silent call CocActionAsync('highlight')
          '';
        };
      };
    };
  };
}
