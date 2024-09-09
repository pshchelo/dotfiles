-- TODO: maxmempattern? need to try on huge files

-- do not force to save buffers when switching to new ones
vim.o.hidden = true

-- allow backspacing over everything in insert mode - NEEDED?
-- vim.o.backspace = 'indent,eol,start'

-- ===========
-- INDENTATION
-- ===========
-- default indentation
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.tabstop = 8
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

vim.o.autoindent = true
-- vim.o.smartindent = true -- might interfere with file type based indentation, and should never be used in conjunction with it
-- copy the previous indentation on autoindenting - needed?
vim.o.copyindent = true

-- ======
-- SEARCH
-- ======

-- ignore case if search pattern is all lowercase, case-sensitive otherwise
vim.o.smartcase = true
-- use incremental search
vim.o.incsearch = true
-- set show matching parenthesis
vim.o.showmatch = true
-- highlight search terms
vim.o.hlsearch = true

-- VISUALS
-- show colored border column
vim.o.colorcolumn = "80"
vim.cmd.highlight({"ColorColumn", "ctermbg=lightgrey", "guibg=lightgrey"})
-- show line numbers
vim.o.number = true
-- hide default mode test (e.g. -- INSERT -- below statusline), use lualine instead
vim.o.showmode = false
-- always show status line
vim.o.laststatus = 2

-- Use this highlight group when displaying bad whitespace is desired.
vim.cmd.highlight({"BadWhitespace", "ctermbg=red", "guibg=red"})
-- nice chars for displaying special symbols with ':set list'
vim.opt.listchars = {
    tab = '→ ',
    space = '·',
    nbsp = '␣',
    trail = '•',
    eol = '¶',
    precedes = '«',
    extends = '»',
}

-- MOUSE -- TODO: needed?
-- vim.o.clipboard = "unnamedplus"
-- vim.o.mouse = "a"
-- vim.o.mousemodel = "popup_setpos"

-- FILE TYPES
vim.o.backup = false
vim.o.swapfile = false
vim.opt.wildignore = {
    '*.swp',
    '*.bak',
    '*.pyc',
    '*.class',
}
-- NeoVim defaults to utf-8 for 'encoding'
vim.opt.fileencodings:append("cp1251")

-- TODO: check the C format function
vim.api.nvim_create_autocmd(
    {"BufRead","BufNewFile"},
    {
        pattern = "*.c,*.h",
        callback = function()
            if vim.fn.search('^\t', 'n', 150) then
                vim.o.shiftwidth = 8
                vim.o.expandtab = false
            else
                vim.o.shoftwidth = 4
                vim.o.expandtab = true
            end
        end,
        desc = "Choose correct tab settings for C files dependent on how TABS are already used",
    }
)
vim.api.nvim_create_autocmd(
    {"BufRead","BufNewFile"},
    {
        pattern = "Makefile*",
        command = [[set noexpandtab]],
        desc = "Disable tab expansion for Makefiles",
    }
)
vim.api.nvim_create_autocmd(
    {"BufRead","BufNewFile"},
    {
        pattern = "*.py,*.pyw,*.pyx",
        command = [[match BadWhitespace /^\t\+/]],
        desc = "Mark leading tabs as bad for Python",
    }
)
vim.api.nvim_create_autocmd(
    {"BufRead","BufNewFile"},
    {
        pattern = "*.py,*.pyw,*.pyx,*.c,*.h",
        command = [[match BadWhitespace /\s\+$/]],
        desc = "Mark trailing whitespace as bad for Python and C",
    }
)
vim.api.nvim_create_autocmd(
    {"BufWritePre"},
    {
        pattern = "*.py,*.pyw,*.pyx,*.c,*.h",
        command = [[:%s/\s\+$//e]],
        desc = "Trim trailing whitespace on save for Python and C",
    }
)
vim.api.nvim_create_autocmd(
    {"BufRead","BufNewFile"},
    {
        pattern = "*.{txt,rst,md}",
        command = [[setlocal spell spelllang=en_us]],
        desc = "Enable En-US spellcheck for RST, MD and TXT",
    }
)
vim.api.nvim_create_autocmd(
    {"BufRead","BufNewFile"},
    {
        pattern = "*.rst",
        command = [[match BadWhitespace /\s\+$/]],
        desc = "Mark trailing whitespace as bad for RST",
    }
)
vim.api.nvim_create_autocmd(
    {"BufWritePre"},
    {
        pattern = "*.rst",
        command = [[:%s/\s\+$//e]],
        desc = "Trim trailing whitespace on save for RST",
    }
)

vim.api.nvim_create_autocmd(
    {"BufRead","BufNewFile"},
    {
        pattern = "*.hot",
        command = [[set filetype=yaml]],
        desc = "Treat OpenStack Heat's HOT files as YAML",
    }
)
vim.api.nvim_create_autocmd(
    {"Filetype"},
    {
        pattern = "yaml,json",
        command = "setlocal ts=2 sw=2 expandtab",
        desc = "Set indentation to 2 for YAML and JSON files",
    }
)
vim.api.nvim_create_autocmd(
    {"Filetype"},
    {
        pattern = "javascript,javascripreact,typescript,typescriptreact",
        command = "setlocal ts=2 sw=2 expandtab",
        desc = "Set indentation to 2 for javascript and typescript etc files",
    }
)
vim.api.nvim_create_autocmd(
    {"BufRead","BufNewFile"},
    {
        pattern = "*.yaml,*.yml,*.hot",
        command = [[match BadWhitespace /\s\+$/]],
        desc = "Mark trailing whitespace as bad for YAML etc files"
    }
)
vim.api.nvim_create_autocmd(
    {"BufWritePre"},
    {
        pattern = "*.yaml,*.yml,*.hot",
        command = [[:%s/\s\+$//e]],
        desc = "Trim trailing whitespace on save for YAML etc files"
    }
)
vim.api.nvim_create_autocmd(
    {"BufRead","BufNewFile"},
    {
        pattern = "*.conf",
        command = [[set filetype=dosini]],
        desc = "Treat *.conf files as DOSINI format",
    }
)

-- =========
-- PROVIDERS
-- =========
vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- !! change core keymappings before that !!
-- ============
-- PLUGINS
-- ============
-- setup lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
local allPlugins = {
    {
        --"altercation/vim-colors-solarized",
        "maxmx03/solarized.nvim",
        lazy=false,
        priority=1000
    },
    {"nvim-tree/nvim-web-devicons"},
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"},
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {"nvim-treesitter/nvim-treesitter"},
    },
    {"neovim/nvim-lspconfig"},
    {"lspcontainers/lspcontainers.nvim"}, -- install and run LSPs in Docker
    {"hrsh7th/nvim-cmp"}, -- Autocompletion plugin
    {"hrsh7th/cmp-nvim-lsp"}, -- LSP source for completions
    {"hrsh7th/cmp-nvim-lsp-signature-help"},  -- Functions signatures autocomplete
    {"hrsh7th/cmp-buffer"}, -- buffer content source for completions
    {"hrsh7th/cmp-path"},  -- file paths source for completions
    {"hrsh7th/cmp-cmdline"}, -- completions for search (/) and command mode
    {
        "petertriho/cmp-git", -- Git source for completions
        dependencies = {"nvim-lua/plenary.nvim"},
    },
    {
        'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
        dependencies = {
            {
                'L3MON4D3/LuaSnip',  -- Snippet engine
                --build = "make install_jsregexp" -- optional, 
            }
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {"nvim-lua/plenary.nvim"},
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
    },
    {"wsdjeg/vim-fetch"}, -- open file paths in log/debug format as file:<line>:<column>
    {"moll/vim-bbye"}, -- close files instead of closing views
    {"scrooloose/nerdcommenter"}, -- nicer (un)comment commands
    {
        "jistr/vim-nerdtree-tabs",
        dependencies = {"scrooloose/nerdtree"}, -- sidebar file browser + in single panel
    },
    {"will133/vim-dirdiff"}, -- use vimdiff on folders
    {"tpope/vim-fugitive"}, -- git commands
    {
        "rbong/vim-flog", -- git log, somehow similar to tig?
        lazy = true,
        cmd = { "Flog", "Flogsplit", "Floggit" },
        dependencies = {"tpope/vim-fugitive"},
    },
    {"lewis6991/gitsigns.nvim"}, -- git signis in the gutter
    {"dense-analysis/ale"}, -- async linter  TODO: evaluate mfussenegger/nvim-lint
    {"lukas-reineke/indent-blankline.nvim", main = "ibl"}, -- indentation giudes
    {"preservim/tagbar"}, -- tagbar, requires universal-ctags
    {"tpope/vim-unimpaired"}, -- pairs of commands
    {"tpope/vim-repeat"}, -- repeat full actions from plugins via .
    {"tpope/vim-surround"}, -- work with surrounding quotes/braces/tags
    {"folke/trouble.nvim"}, -- nicer display of diagnostics
    {
        --"folke/todo-comments.nvim", -- better work with comment prefixes
        -- NOTE: this is PR#255 in the main repo, that can properly highlight e.g. NOTE(name):
        -- TODO: move back to main repo once the PR is merged
        "LunarLambda/todo-comments.nvim",
        branch = "enhanced-matching",
        dependencies = {"nvim-lua/plenary.nvim"},
    },
    {"folke/lsp-colors.nvim"}, -- add missing LSP color groups to colorschemes
    {"gu-fan/riv.vim"}, -- reStructouredText support
    {"HiPhish/jinja.vim"}, -- Jinja2 syntax support
    {"towolf/vim-helm", ft='helm'}, -- yaml + gotmpl + sprig + custom, but would treesitter suffice?
    {"vmware-archive/salt-vim", ft={"yaml", "helm", "sls"}}, -- saltstack, good for yaml + Jinja2
    {
        "fatih/vim-go", -- Golang
        ft='go',
        enabled=vim.fn.executable('go')~=0,
    },
    {
        "eagletmt/ghcmod-vim", -- Haskell
        ft='haskell',
        enabled=vim.fn.executable('ghc')~=0,
    },
    {
        "lervag/vimtex", -- LaTex
        ft={"latex", "tex"},
        enabled=vim.fn.executable("latex")~=0,
    },
    -- TODO: evaluate necessity for more plugins:
    -- mg979/vim-visual-multi? multi-cursor
    -- pshchelo/lodgeit.vim ?? re-write in lua?
    -- jiangmiao/auto-pairs?
    -- jeetsukumaran/vim-pythonsense? do I really need it? would treesitter suffice?
}
require("lazy").setup(allPlugins)
-- ===============
-- PLUGIN SETTINGS
-- ===============
-- solarized color scheme
vim.o.background = "dark"
require("solarized").setup({})
vim.cmd.colorscheme("solarized")

-- lualine
-- TODO: integrate with ale? Trouble?
require('lualine').setup({
    options = { theme = "auto" },
    tabline = {
        lualine_a = {'buffers'},
        lualine_z = {'tabs'}
    },
})

-- LSP and autocomplete settings
local cmp = require("cmp")
local luasnip = require("luasnip")
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local completeOnTab = function(fallback)
    if cmp.visible() then
        cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    elseif has_words_before() then
        cmp.complete()
    else
        fallback()
    end
end
local completeOnShiftTab = function(fallback)
    if cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
    else
        fallback()
    end
end
cmp.setup({
    completion = {
        keyword_length = 3,
    },
    snippet = {},
    window = {
       completion = cmp.config.window.bordered(),
       documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping(completeOnTab, { "i", "s" }),
        ["<s-Tab>"] = cmp.mapping(completeOnShiftTab, { "i", "s" }),
        ["<Space>"] = cmp.mapping.abort(),
        -- Accept currently selected item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm({ select=false }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp', keyword_length = 3, },
        { name = 'buffer', keyword_length = 3, },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' }, -- For luasnip users.
        --{ name = 'vsnip' }, -- For vsnip users.
        --{ name = 'ultisnips' }, -- For ultisnips users.
        --{ name = 'snippy' }, -- For snippy users.
    })
})
cmp.setup.filetype(
    'gitcommit',
    {
        sources = cmp.config.sources({
          { name = 'git', keyword_length = 3, },
        }, {
          { name = 'buffer', keyword_length = 3, },
        })
    }
)
require("cmp_git").setup()

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer', keyword_length = 3, }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path', keyword_length = 3, }
  }, {
    { name = 'cmdline', keyword_length = 3, }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require("lspconfig")

local function find_venv()

  -- If there is an active virtual env, use that
  if vim.env.VIRTUAL_ENV then
    return { vim.env.VIRTUAL_ENV .. "/bin/python" }
  end

  -- Search within the current git repo to see if we can find a virtual env to use.
  local repo = lspconfig.util.find_git_ancestor(vim.fn.getcwd())
  if not repo then
    return nil
  end

  local candidates = vim.fs.find("pyvenv.cfg", { path = repo })
  if #candidates == 0 then
    return nil
  end

  return { vim.fn.resolve(candidates[1] .. "./../bin/python") }
end

-- lspconfig does not fail when langserver is not available, just prints a warning in status line
lspconfig.pylsp.setup({
    capabilities = capabilities,
    settings = {
        pylsp = {
            configurationSources = {"ruff", "flake8"},
            plugins = {
                pycodestyle = {
                    enabled = false
                },
                mccabe = {
                    enabled = false
                },
                pyflakes = {
                    enabled = false
                },
                flake8 = {
                    enabled = true
                },
                pylsp_black = {
                    enabled = true,
                },
                ruff = {
                    enabled = true,
                },
                pylsp_mypy = {
                    enabled = false,
                },
            },
        },
    },
})

vscode_servers = {
    cssls = "vscode-css-language-server",
    eslint = "vscode-eslint-language-server",
    --markdown = "vscode-markdown-language-server",
}
for lspname, server in pairs(vscode_servers) do
    if vim.fn.executable(server)~=0 then
        lspconfig[lspname].setup { capabilites = capabilites }
    end
end

local before_init_container = function(params)
    params.processId = vim.NIL
end

local tsserver_setup = { capabilites = capabilites }
if vim.fn.executable('tsserver')~=0 then
    tsserver_setup["cmd"] = { 'tsserver', '--stdio' }
else
    tsserver_setup["before_init"] = before_init_container
    tsserver_setup["cmd"] = require'lspcontainers'.command('tsserver')
end
lspconfig.ts_ls.setup(tsserver_setup)

local containerized_servers = {
    html = "vscode-html-language-server",
    jsonls = "vscode-json-language-server",
    tailwindcss = "tailwindcss-language-server",
}
for lspname, server in pairs(containerized_servers) do
    local config = { capabilites = capabilites }
    if vim.fn.executable(server)==0 then
        config["before_init"] = before_init_container
        config["cmd"] = require'lspcontainers'.command(lspname)
    end
    lspconfig[lspname].setup(config)
end

-- RST/Sphinx LSP
--lspconfig.esbonio.setup({
--  settings = {
--    sphinx = { pythonCommand = find_venv() }
--  }
--})

-- TREE-SITTER
require("nvim-treesitter.configs").setup({
    -- ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "python"},
    ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "javascript",
        "css",
        "html",
        "css",
        "python",
        "rst",
        "go",
        "helm",
        "bash",
        "dockerfile",
        "json",
        "yaml",
        "xml",
        "toml",
        "comment",
    },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = { -- TODO: move to keymaps section, configure separately
            init_selection = "gnn", -- set to `false` to disable one of the mappings
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
    },
  },
})
-- FOLDING
vim.o.foldmethod = "expr" -- for treesitter
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
-- start with all open folds
vim.o.foldenable = false

-- INDENT-BLANKLINE
require("ibl").setup({
    indent = {
        char = {'▏', '|', '¦', '┆', '┊'},
        --char = '▏',
    }
})

-- TELESCOPE
require('telescope').setup({
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
})
require('telescope').load_extension('fzf')

-- GITSIGNS
require('gitsigns').setup({
    signs = {
        add = {text = "+"},
        change = {text = "!"},
        delete = {text = "_"},
    },
})

-- NERDCOMMENTER
vim.g.NERDSpaceDelims = 0
vim.g.NERDDefaultAlign = "left"
-- Use octothorpe for comments in ini/conf files, keep ; as alternative
vim.g.NERDCustomDelimiters = { dosini = {left = "#", leftAlt = ";"} }

-- NERDTree
vim.g.NERDTreeIgnore = {[[\.pyc$]]}

-- ALE
--vim.g.airline#extensions#ale#enabled = 1
vim.g.ale_sign_error = "✗"
vim.g.ale_sign_warning = "⚠"
vim.g.ale_sign_info = "🛈"
vim.g.ale_open_list = 1
vim.g.ale_linters = {python = {},}
vim.g.ale_lint_on_enter = 0
vim.g.ale_lint_on_insert_leave = 1
vim.g.ale_lint_on_text_changed = "normal"

-- todo-comments
require("todo-comments").setup({
    signs = false,
    -- NOTE: this depends on fork/PR in the original plugin repo for now
    highlight = {
      -- vimgrep regex, supporting the pattern TODO(name):
      pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
    },
    search = {
      -- ripgrep regex, supporting the pattern TODO(name):
      pattern = [[\b(KEYWORDS)(\(\w*\))*:]],
    },
})

-- =======
-- KEYMAPS
-- =======

-- add Ukr lang input, toggle in insert mode with <C-6>
vim.o.keymap = 'ukrainian-jcuken'
-- use QWERTY Eng lang by default
vim.o.iminsert = 0
vim.cmd("au BufRead * silent setlocal iminsert=0")

--vim.o.pastetoggle = "<leader>p" -- NEEDED? might not be that needed in NeoVim

local toggle_background = function()
    if vim.o.background == "dark" then
        vim.o.background = 'light'
    elseif vim.o.background == 'light' then
        vim.o.background = 'dark'
    end
end

vim.keymap.set(
    "n", "<F5>", toggle_background,
    {
        silent = true,
        desc = "Toggle between light and dark backgrounds",
    }
)
vim.keymap.set(
    "n", "<Space>", ":nohlsearch<Bar>:echo<CR>",
    {
        silent = true,
        desc = "turn off active search highlighting",
    }
)

vim.keymap.set(
    "n", "<leader>s", ":setlocal spell! spelllang=en_us<CR>",
    {desc = "Toggle spellcheck (uses En-US)"}
)

vim.keymap.set(
    "n", "<leader>zz", ':let &scrolloff=999-&scrolloff<CR>:echo "scrolloff toggled"<CR>',
    {desc = "Toggle vertical centring of the cursor"}
)

vim.keymap.set(
    "n", "<leader>L", ":set list!<CR>",
    {desc = "Toggle display of special characters"}
)

vim.keymap.set(
    "n", "<leader>N", function()
        -- toggle line numbers
        vim.o.number = not vim.o.number;
        -- togle signs
        vim.o.signcolumn = vim.o.signcolumn == "auto" and "no" or "auto";
        -- toggle indentation guides
        vim.cmd("IBLToggle");
        -- TODO: toggle relativenumber too?
    end,
    {desc = "Toggle line numbers and others to enable raw copy from terminal"}
)

vim.keymap.set(
    "n", "<leader>W", [[:%s/\s\+$//e<CR>]],
    {desc = "Remove trailing whitespace"}
)

vim.keymap.set(
    "n", "<leader>T", ":retab<CR>",
    {desc = "Replace tabs with spaces"}
)

-- FIXME: forced sudo does not work as is
--vim.keymap.set(
--    "c", "w!!", "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!",
--    {desc = "Write to file anyway if having enough permissions"}
--)

-- Python breakpoints
vim.api.nvim_create_autocmd(
    "Filetype",
    {
        pattern = "python",
        callback = function()
            vim.keymap.set(
                "n", "<leader>B", "yyP^Cimport rpdb; rpdb.set_trace()  # XXX:breakpoint<Esc>",
                {desc = "Set rpdb breakpoint in Python"}
            )
        end,
    }
)
vim.api.nvim_create_autocmd(
    "Filetype",
    {
        pattern = "python",
        callback = function()
            if vim.fn.has("python3") == 1 then
                vim.keymap.set(
                    "n", "<leader>b", "yyP^Cbreakpoint()  # XXX:breakpoint<Esc>",
                    {desc = "Set py3.6+ breakpoint in Python (defaults to pdb)"}
                )
            else
                vim.keymap.set(
                    "n", "<leader>b", "yyP^Cimport pdb; pdb.set_trace()  # XXX:breakpoint<Esc>",
                    {desc = "Set pdb breakpoint in Python"}
                )
            end
        end,
    }
)

-- vim-bbye
vim.keymap.set(
    "n", "<leader>q", ":Bdelete<CR>",
    {desc = "Close buffers without closing windows"}
)

-- NERDTree
vim.keymap.set(
    "n", "<F3>", ":NERDTreeToggle %<CR>",
    {desc = "Toggle NERDTREE file browser side bar"}
)

-- tagbar
vim.keymap.set(
    "n", "<F4>", ":TagbarToggle<CR>",
    {desc = "Toggle Tags side bar (code structore outline)"}
)

-- TELESCOPE
vim.keymap.set(
    'n', '<C-p>', function() require('telescope.builtin').git_files({hidden=true}) end,
    {desc = "Search files .. TODO"}
)
vim.keymap.set(
    'n', '<C-P>', function() require('telescope.builtin').find_files({hidden=true}) end,
    {desc = "Seatch files .. TODO"}
)
vim.keymap.set(
    'n', '<C-f>f', function() require('telescope.builtin').live_grep({hidden=true}) end,
    {desc = "Search for word with incremental live feedback"}
)
vim.keymap.set(
    'n', '<C-f>n', function() require('telescope.builtin').grep_string({hidden=true}) end,
    {desc = "Search word under cursor or selected"}
)

--vim.cmd("sign define LspDiagnosticsSignError text=🔴")
--vim.cmd("sign define LspDiagnosticsSignWarning text=🟠")
--vim.cmd("sign define LspDiagnosticsSignInformation text=🔵")
--vim.cmd("sign define LspDiagnosticsSignHint text=🟢")
-- LSP actions
vim.keymap.set(
    "n", "gd", vim.lsp.buf.definition,
    {
        silent = true,
        desc = "LSP: Go to definition"
    }
)
vim.keymap.set(
    "n", "gi", vim.lsp.buf.implementation,
    {
        silent = true,
        desc = "LSP: Go to implementation"
    }
)
vim.keymap.set(
    "n", "gD", vim.lsp.buf.declaration,
    {
        silent = true,
        desc = "LSP: Go to declaration"
    }
)
vim.keymap.set(
    "n", "gr", vim.lsp.buf.references,
    {
        silent = true,
        desc = "LSP: Show references"
    }
)
-- FIXME:
vim.keymap.set(
    "n", "ge", vim.diagnostic.setloclist,
    {
        silent = true,
        desc = "LSP: Add buffer diagnostics to the location list"
    }
)
vim.keymap.set(
    "n", "K", vim.lsp.buf.hover,
    {
        silent = true,
        desc = "LSP: Hover documentation"
    }
)
vim.keymap.set(
    "n", "<C-K>", vim.lsp.buf.signature_help,
    {
        silent = true,
        desc = "LSP: Signature documentation"
    }
)
vim.keymap.set(
    "n", "<leader>f", vim.lsp.buf.format,
    {
        silent = true,
        desc = "LSP: format buffer"
    }
)
vim.keymap.set(
    "n", "<leader>rn", vim.lsp.buf.rename,
    {
        silent = true,
        desc = "LSP: rename symbol"
    }
)
vim.keymap.set(
    {"x", "n"}, "<leader>a", vim.lsp.buf.code_action,
    {
        silent = true,
        desc = "LSP: show available code actions"
    }
)
--vim.keymap.set(
--    "x", "<leader>a", vim.lsp.buf.range_code_action,
--    {
--        silent = true,
--        desc = "LSP: show available code actions for a range of lines"
--    }
--)

vim.keymap.set(
    'n', '=l',
    function()
        local win = vim.api.nvim_get_current_win()
        local ll_winid = vim.fn.getloclist(win, { winid = 0 }).winid
        local action = ll_winid > 0 and 'lclose' or 'lopen'
        vim.cmd(action)
    end,
    {
        noremap = true,
        silent = true,
        desc = "Toggle LocList",
    }
)

vim.keymap.set(
    'n', '=q',
    function()
        local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
        local action = qf_winid > 0 and 'cclose' or 'copen'
        vim.cmd('botright '..action)
    end,
    {
        noremap = true,
        silent = true,
        desc = "Toggle QuickFixList",
    }
)

-- GUI
if vim.g.neovide then
    vim.o.guifont = "AnonymicePro Nerd Font:h20"
end
--  USEFUL UNICODE SYMBOLS
--  check marks/crosses ✅ ✓ ✔ ✗ ✘ 🗴 🗶 🗸
--  more ⚠ ♨ ⚡ ⌥ ⌦ ⎇  🗲 ‣ 🛈
--  Powerline symbols (from private Unicode space)
--        
-- vertical lines from unicode 'Box Drawing' and 'Block elements'
-- {"▏", "▎", "▍", "▌", "▋", "▊", "▉", "█"} -- left aligned solid
-- {"│", "┃"} -- center aligned solid
-- {"▕", "▐"} -- right aligned solid
-- {"╎", "╏", "┆", "┇", "┊", "┋" } -- center aligned dashed
-- {"║"} -- center aligned double
--
-- ### SUMMARY OF CUSTOM KEYMAPS ###

-- === Autocompletion ===
-- Ctrl-b     - scroll docs up
-- Ctrl-f     - scroll docs down
-- Ctrl-Space - complete symbol
-- Tab        - cycle over completions
-- Shift-Tab  - cycle back over completions
-- Space      - abort completion
-- Enter      - accept completion

-- === LSP actions ===
-- gd - go to definition
-- gD - go to declaration
-- gi - go to implementation
-- gr - list references
-- ge - put diagnostics into LocList
-- K  - docs popup
-- Ctrl-K - Signature docs
-- <Leader>-f - format buffer
-- <Leader>-rn - rename symbol
-- <leader>-a - show other code actions

-- === Treesitter ===
-- gnn - init selection - select innner most code unit
-- grn - node incremental - expand selection one code unit level
-- grm - node decremental - shrink selection one code unit level
-- grc - scope incremental

-- === Telescope ===
-- Ctrl-p - git_files
-- Ctrl-P - find_files
-- Ctrl-f f - live_grep - search for word with incremental live feedback
-- Ctrl-f n - grep_string - search for word under cursor (or selection)

-- === Other ===
-- F3 - toggle NerdTree file browser
-- F4 - toggle code structure outline sidebar
-- F5 - toggle between dark and light
-- Space - unhighlight search results
-- =l - toggle LocList
-- =q - toggle QuickFixList
-- <leader>s - toggle EN_US spellcheck
-- <leader>zz - toggle vertical center of cursor
-- <leader>L - toggle display of special symbols
-- <leader>N - toggle display of line numbers, signs and indent guides
-- <leader>W - remove trailing whitespace
-- <leader>T - replace tabs with spaces
-- <leader>B - Python - insert rpdb breakpoint
-- <leader>b - Python - insert standard breakpoint
-- <leader>q - close buffer w/o closing window (vim-bbye)
