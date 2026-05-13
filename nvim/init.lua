-- TODO: maxmempattern? need to try on huge files

-- do not force to save buffers when switching to new ones
vim.o.hidden = true

-- allow backspacing over everything in insert mode - NEEDED?
-- vim.o.backspace = "indent,eol,start"

-- =======
-- VISUALS
-- =======
-- apparently fixes borked colors in mosh session
-- https://github.com/mobile-shell/mosh/issues/928
vim.o.termguicolors = true
-- show colored border column
vim.o.colorcolumn = "80"
-- show line numbers
vim.o.number = true
-- hide default mode test (e.g. -- INSERT -- below statusline), use lualine instead
vim.o.showmode = false
-- always show status line
vim.o.laststatus = 2
-- nice chars for displaying special symbols with ":set list"
vim.opt.listchars = {
    tab = "→ ",
    space = "·",
    nbsp = "␣",
    trail = "•",
    eol = "¶",
    precedes = "«",
    extends = "»",
}


-- ======
-- COLORS
-- ======
local setCustomHighlights = function()
    -- Use this highlight group when displaying bad whitespace is desired.
    vim.cmd.highlight({"BadWhitespace", "ctermbg=red", "guibg=red"})
    -- Change how spellcheck highlights wrong words
    vim.cmd.highlight({"clear", "SpellBad"})
    vim.cmd.highlight({"SpellBad", "cterm=underline", "guisp=red"})
    vim.cmd.highlight({"SpellBad", "gui=undercurl", "guisp=red"})
end

-- ===
-- GUI
-- ===
if vim.g.neovide then
    vim.o.guifont = "AnonymicePro Nerd Font:h20"
end


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

-- =====
-- MOUSE
-- =====
vim.o.clipboard = "unnamedplus"
vim.o.mouse = "a"
vim.o.mousemodel = "popup_setpos"

-- ==========
-- FILE TYPES
-- ==========
vim.o.backup = false
vim.o.swapfile = false
vim.opt.wildignore = {
    "*.swp",
    "*.bak",
    "*.pyc",
    "*.class",
}
-- NeoVim defaults to utf-8 for "encoding"
vim.opt.fileencodings:append("cp1251")

-- TODO: check the C format function
vim.api.nvim_create_autocmd(
    {"BufRead","BufNewFile"},
    {
        pattern = "*.c,*.h",
        callback = function()
            if vim.fn.search("^\t", "n", 150) then
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
-- =======
-- PLUGINS
-- =======
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
    {"romus204/tree-sitter-manager.nvim"},
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
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
        "saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
        dependencies = {
            {
                "L3MON4D3/LuaSnip",  -- Snippet engine
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
    {
        "X3eRo0/dired.nvim", -- analog to emacs' dired mode
        dependencies = {"MunifTanjim/nui.nvim"},
    },
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
        "folke/todo-comments.nvim", -- better work with comment prefixes
        dependencies = {"nvim-lua/plenary.nvim"},
    },
    {"folke/lsp-colors.nvim"}, -- add missing LSP color groups to colorschemes
    {"gu-fan/riv.vim"}, -- reStructouredText support
    {"HiPhish/jinja.vim"}, -- Jinja2 syntax support
    {"towolf/vim-helm", ft="helm"}, -- yaml + gotmpl + sprig + custom, but would treesitter suffice?
    {"vmware-archive/salt-vim", ft="sls"}, -- saltstack, good for yaml + Jinja2
    {
        "fatih/vim-go", -- Golang
        ft="go",
        enabled=vim.fn.executable("go")~=0,
    },
    {
        "eagletmt/ghcmod-vim", -- Haskell
        ft="haskell",
        enabled=vim.fn.executable("ghc")~=0,
    },
    {
        "lervag/vimtex", -- LaTex
        ft={"latex", "tex"},
        enabled=vim.fn.executable("latex")~=0,
    },
    -- AI completion playground
    {
        "tzachar/cmp-ai", -- llm source for nvim-cmp, supports ollama and HF
        dependencies={"nvim-lua/plenary.nvim"},
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
setCustomHighlights()

-- lualine
-- TODO: integrate with ale? Trouble?
require("lualine").setup({
    options = { theme = "auto" },
    tabline = {
        lualine_a = {"buffers"},
        lualine_z = {"tabs"}
    },
})

-- AI helpers
-- ollama via cmp-ai
require("cmp_ai.config"):setup({
  -- TODO: figure out how to auto-toggle local or remote IP
  --base_url = "http://127.0.0.1:11434/api/generate", -- this is default
  max_lines = 100,
  provider = "Ollama",
  provider_options = {
    model = "gemma4",
    auto_unload = false, -- Set to true to automatically unload the model when
                        -- exiting nvim.
  },
  notify = true,
  notify_callback = function(msg)
    vim.notify(msg)
  end,
  run_on_every_keystroke = true,
})

-- autocomplete settings
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
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping(completeOnTab, { "i", "s" }),
        ["<s-Tab>"] = cmp.mapping(completeOnShiftTab, { "i", "s" }),
        ["C-e>"] = cmp.mapping.abort(),
        -- Accept currently selected item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm({ select=true }),
        ["C-x"] = cmp.mapping.complete({
            config = {
                sources = cmp.config.sources({
                    { name = "cmp_ai" },
                })
            }
        },
        {"i",}), -- explicitly ask for completion using cmp_ai
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp", keyword_length = 3, },
        { name = "buffer", keyword_length = 3, },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip" },
        { name = "path", keyword_length = 3, }
    })
})
cmp.setup.filetype(
    "gitcommit",
    {
        sources = cmp.config.sources({
          { name = "git", keyword_length = 3, },
          { name = "buffer", keyword_length = 3, },
        })
    }
)
require("cmp_git").setup()

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer", keyword_length = 3, }
  }
})

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path", keyword_length = 3, },
    { name = "cmdline", keyword_length = 3, },
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

--- LSP settings
vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- lspconfig does not fail when langserver is not available, just prints a warning in status line
-- Python type checker and general LSP
vim.lsp.config("ty", {
    capabilites = capabilites,
    settings = {
        ty = {
            showSyntaxErrors = false,
        },
    },
})
vim.lsp.enable("ty")

-- Python linter and formatter
vim.lsp.config("ruff", {
    capabilites = capabilites,
    init_options = {
        settings = {
            configurationPreference = "filesystemFirst",
            lineLength = 79,
            lint = {
                preview = true
            },
            format = {
                preview = true
            },
        },
    },
})
vim.lsp.enable("ruff")

-- Golang lsp
vim.lsp.config("gopls", {
    capabilites = capabilites,
})
vim.lsp.enable("gopls")

vscode_servers = {
    cssls = "vscode-css-language-server",
    eslint = "vscode-eslint-language-server",
    --markdown = "vscode-markdown-language-server",
}
for lspname, server in pairs(vscode_servers) do
    if vim.fn.executable(server)~=0 then
        vim.lsp.enable(lspname)
        vim.lsp.config(lspname, { capabilites = capabilites })
    end
end

local before_init_container = function(params)
    params.processId = vim.NIL
end

local lsp_container_config = {}
if vim.fn.executable("podman")~=0 then
    lsp_container_config["container_runtime"] = "podman"
else
    lsp_container_config["container_runtime"] = "docker"
end

local tsserver_setup = { capabilites = capabilites }
if vim.fn.executable("tsserver")~=0 then
    tsserver_setup["cmd"] = { "tsserver", "--stdio" }
else
    tsserver_setup["before_init"] = before_init_container
    tsserver_setup["cmd"] = require"lspcontainers".command(
        "tsserver", lsp_container_config)
end
vim.lsp.config("ts_ls", tsserver_setup)
vim.lsp.enable("ts_ls")

local containerized_servers = {
    html = "vscode-html-language-server",
    jsonls = "vscode-json-language-server",
    tailwindcss = "tailwindcss-language-server",
}
for lspname, server in pairs(containerized_servers) do
    local config = { capabilites = capabilites }
    if vim.fn.executable(server)==0 then
        config["before_init"] = before_init_container
        config["cmd"] = require"lspcontainers".command(
            lspname, lsp_container_config)
    end
    vim.lsp.config(lspname, config)
    vim.lsp.enable(lspname)
end

vim.lsp.config("clangd", {
    capabilities = capabilities,
    -- pass custom options to clangd server if needed
    -- cmd = { "clangd", "--some-flag=flag-value" },
})
vim.lsp.enable("clangd")

-- RST/Sphinx LSP
--local function find_venv()

--  -- If there is an active virtual env, use that
--  if vim.env.VIRTUAL_ENV then
--    return { vim.env.VIRTUAL_ENV .. "/bin/python" }
--  end

--  -- Search within the current git repo to see if we can find a virtual env to use.
--  local repo = require("lspconfig.util").find_git_ancestor(vim.fn.getcwd())
--  if not repo then
--    return nil
--  end

--  local candidates = vim.fs.find("pyvenv.cfg", { path = repo })
--  if #candidates == 0 then
--    return nil
--  end

--  return { vim.fn.resolve(candidates[1] .. "./../bin/python") }
--end
--vim.lsp.config("esbonio", {
--  settings = {
--    sphinx = { pythonCommand = find_venv() }
--  }
--})
--vim.lsp.enable("esbonio")

-- TREE-SITTER
require("tree-sitter-manager").setup({
    ensure_installed = {
        "bash",
        "c",
        "comment",
        "cpp",
        "css",
        "csv",
        "dockerfile",
        "go",
        --"haskell",
        "helm",
        "html",
        "javascript",
        "json",
        --"latex",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "rst",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
    },
})
-- FOLDING
vim.o.foldmethod = "indent"
-- start with all open folds
vim.o.foldenable = false
-- prevent auto-folding everything upon manual folding with zc, za etc
vim.o.foldlevel = 99

-- TODO: check how setup treesitter-based indent and folding in nvim 0.12 w/o nvim-treesitter
--
--vim.api.nvim_create_autocmd("FileType", { 
--  desc = "Set folding and indent method with treesitter if available for filetype",
--  callback = function() 
--    if vim.treesitter.parsers.has_parser() then
--        -- Enable treesitter highlighting and disable regex syntax
--        pcall(vim.treesitter.start) 
--        -- Enable treesitter-based indentation
--        vim.bo.indentexpr = vim.treesitter.indentexpr() 
--        vim.o.foldmethod = "expr"
--        vim.o.foldexpr = "vim.treesitter#foldexpr()" -- find what's native replacement in nvim 0.12 is
--    end
--  end, 
--}) 
--vim.api.nvim_create_autocmd({ "FileType", "BufRead" }, {
--    desc = "Set folding method with treesitter if available for filetype",
--    callback = function()
--        if require("nvim-treesitter.parsers").has_parser() then
--            vim.o.foldmethod = "expr"
--            vim.o.foldexpr = "nvim_treesitter#foldexpr()"
--        else
--            vim.o.foldmethod = "indent"
--        end
--    end,
--})

-- INDENT-BLANKLINE
require("ibl").setup({
    indent = {
        char = {"▏", "|", "¦", "┆", "┊"},
        --char = "▏",
    }
})

-- TELESCOPE
require("telescope").setup({
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        width = { padding = 0 },
        height = { padding = 0 },
        preview_width = 0.5,
      },
    },
  },
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
require("telescope").load_extension("fzf")

-- GITSIGNS
require("gitsigns").setup({
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

-- Dired
require("dired").setup({
    path_separator = "/",
    show_banner = false,
    show_icons = false,
    show_hidden = true,
    show_dot_dirs = true,
    show_colors = true,
})

-- ALE
--vim.g.airline#extensions#ale#enabled = 1
vim.g.ale_sign_error = "✗"
vim.g.ale_sign_warning = "⚠"
vim.g.ale_sign_info = ""
vim.g.ale_open_list = 1
vim.g.ale_lint_on_enter = 0
vim.g.ale_lint_on_insert_leave = 1
vim.g.ale_lint_on_text_changed = "normal"
-- specific linters settings
vim.g.ale_linters = {python = {},}
vim.g.ale_sh_bashate_options = "-i E006"

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

-- Trouble
require("trouble").setup({
    cmd="Trouble",
})
-- =======
-- KEYMAPS
-- =======

-- add Ukr lang input, toggle in insert mode with <C-6>
vim.o.keymap = "ukrainian-jcuken"
-- use QWERTY Eng lang by default
vim.o.iminsert = 0
vim.cmd("au BufRead * silent setlocal iminsert=0")

--vim.o.pastetoggle = "<leader>p" -- NEEDED? might not be that needed in NeoVim

local toggle_background = function()
    if vim.o.background == "dark" then
        vim.o.background = "light"
    elseif vim.o.background == "light" then
        vim.o.background = "dark"
    end
    setCustomHighlights()
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
    "n", "<leader>zz", ":let &scrolloff=999-&scrolloff<CR>:echo 'scrolloff toggled'<CR>",
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
--
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
            vim.keymap.set(
                "n", "<leader>bb", "yyP^Cfrom remote_pdb import set_trace; set_trace()  # XXX:breakpoint<Esc>",
                {desc = "Set remote-pdb breakpoint in Python"}
            )
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
    "n", "<F3>", function()
        vim.cmd("NERDTreeToggle "..vim.api.nvim_buf_get_name(0))
    end,
    {desc = "Toggle NERDTRee file browser side bar"}
)

-- tagbar
vim.keymap.set(
    "n", "<F4>", ":TagbarToggle<CR>",
    {desc = "Toggle Tags side bar (code structore outline)"}
)

-- TELESCOPE
vim.keymap.set(
    "n", "<C-p>", function() require("telescope.builtin").git_files() end,
    {desc = "Search files .. TODO"}
)
vim.keymap.set(
    "n", "<C-P>", function() require("telescope.builtin").find_files({hidden=true,no_ignore=true}) end,
    {desc = "Seatch files .. TODO"}
)
vim.keymap.set(
    "n", "<C-f>f", function() require("telescope.builtin").live_grep({hidden=true}) end,
    {desc = "Search for word with incremental live feedback"}
)
vim.keymap.set(
    "n", "<C-f>n", function() require("telescope.builtin").grep_string({hidden=true}) end,
    {desc = "Search word under cursor or selected"}
)

vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✗",
      [vim.diagnostic.severity.WARN]  = "⚠",
      [vim.diagnostic.severity.INFO]  = "",
      [vim.diagnostic.severity.HINT]  = "",
    },
  },
})
-- LSP actions
vim.keymap.set(
    "n", "gd", vim.lsp.buf.definition,
    {
        silent = true,
        desc = "LSP: Go to definition"
    }
)
vim.keymap.set(
    "n", "gD", vim.lsp.buf.declaration,
    {
        silent = true,
        desc = "LSP: Go to declaration"
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
    "n", "<leader>f", vim.lsp.buf.format,
    {
        silent = true,
        desc = "LSP: format buffer"
    }
)

vim.keymap.set(
    "n", "<leader>xx", ":Trouble diagnostics toggle filter.buf=0<CR>",
    {
        silent = true,
        desc = "Buffer Diagnostics (Trouble)"
    }
)
vim.keymap.set(
    "n", "<leader>xX", ":Trouble diagnostics toggle<CR>",
    {
        silent = true,
        desc = "Diagnostics (Trouble)"
    }
)
vim.keymap.set(
    "n", "<leader>cs", ":Trouble symbols toggle focus=false<CR>",
    {
        silent = true,
        desc = "Symbols (Trouble)"
    }
)
vim.keymap.set(
    "n", "<leader>cl", ":Trouble lsp toggle focus=false win.position=right<CR>",
    {
        silent = true,
        desc = "LSP Definitions / references / ... (Trouble)"
    }
)
vim.keymap.set(
    "n", "<leader>xL", ":Trouble loclist toggle<CR>",
    {
        silent = true,
        desc = "Location List (Trouble)"
    }
)
vim.keymap.set(
    "n", "<leader>xQ", ":Trouble qflist toggle<CR>",
    {
        silent = true,
        desc = "Quickfix List (Trouble)"
    }
)


vim.keymap.set(
    "n", "=l",
    function()
        local win = vim.api.nvim_get_current_win()
        local ll_winid = vim.fn.getloclist(win, { winid = 0 }).winid
        local action = ll_winid > 0 and "lclose" or "lopen"
        vim.cmd(action)
    end,
    {
        noremap = true,
        silent = true,
        desc = "Toggle LocList",
    }
)

vim.keymap.set(
    "n", "=q",
    function()
        local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
        local action = qf_winid > 0 and "cclose" or "copen"
        vim.cmd("botright "..action)
    end,
    {
        noremap = true,
        silent = true,
        desc = "Toggle QuickFixList",
    }
)

--  USEFUL UNICODE SYMBOLS (peeked by "uni" tool https://github.com/arp242/uni)
--              Dec    UTF8        HTML       Name
-- "✅" U+2705  9989   e2 9c 85    &#x2705;   WHITE HEAVY CHECK MARK
-- "✓"  U+2713  10003  e2 9c 93    &check;    CHECK MARK
-- "✔"  U+2714  10004  e2 9c 94    &#x2714;   HEAVY CHECK MARK
-- "✗"  U+2717  10007  e2 9c 97    &cross;    BALLOT X
-- "✘"  U+2718  10008  e2 9c 98    &#x2718;   HEAVY BALLOT X
-- "🗴"  U+1F5F4 128500 f0 9f 97 b4 &#x1f5f4;  BALLOT SCRIPT X [x mark]
-- "🗶"  U+1F5F6 128502 f0 9f 97 b6 &#x1f5f6;  BALLOT BOLD SCRIPT X
-- "🗸"  U+1F5F8 128504 f0 9f 97 b8 &#x1f5f8;  LIGHT CHECK MARK [check]
-- "⚠"  U+26A0  9888   e2 9a a0    &#x26a0;   WARNING SIGN
-- "♨"  U+2668  9832   e2 99 a8    &#x2668;   HOT SPRINGS
-- "⚡" U+26A1  9889   e2 9a a1    &#x26a1;   HIGH VOLTAGE SIGN [thunder, lightning symbol]
-- "⌥"  U+2325  8997   e2 8c a5    &#x2325;   OPTION KEY
-- "⌦"  U+2326  8998   e2 8c a6    &#x2326;   ERASE TO THE RIGHT [delete to the right key]
-- "⎇"  U+2387  9095   e2 8e 87    &#x2387;   ALTERNATIVE KEY SYMBOL
-- "🗲"  U+1F5F2 128498 f0 9f 97 b2 &#x1f5f2;  LIGHTNING MOOD [lightning bolt]
-- "‣"  U+2023  8227   e2 80 a3    &#x2023;   TRIANGULAR BULLET
-- "🛈"  U+1F6C8 128712 f0 9f 9b 88 &#x1f6c8;  CIRCLED INFORMATION SOURCE [information]
-- "💡" U+1F4A1 128161 f0 9f 92 a1 &#x1f4a1;  ELECTRIC LIGHT BULB [idea]
-- "🔴" U+1F534 128308 f0 9f 94 b4 &#x1f534;  LARGE RED CIRCLE
-- "🟠" U+1F7E0 128992 f0 9f 9f a0 &#x1f7e0;  LARGE ORANGE CIRCLE
-- "🔵" U+1F535 128309 f0 9f 94 b5 &#x1f535;  LARGE BLUE CIRCLE
-- "🟢" U+1F7E2 128994 f0 9f 9f a2 &#x1f7e2;  LARGE GREEN CIRCLE
-- "▏"  U+258F  9615   e2 96 8f    &#x258f;   LEFT ONE EIGHTH BLOCK
-- "▎"  U+258E  9614   e2 96 8e    &#x258e;   LEFT ONE QUARTER BLOCK
-- "▍"  U+258D  9613   e2 96 8d    &#x258d;   LEFT THREE EIGHTHS BLOCK
-- "▌"  U+258C  9612   e2 96 8c    &#x258c;   LEFT HALF BLOCK
-- "▋"  U+258B  9611   e2 96 8b    &#x258b;   LEFT FIVE EIGHTHS BLOCK
-- "▊"  U+258A  9610   e2 96 8a    &#x258a;   LEFT THREE QUARTERS BLOCK
-- "▉"  U+2589  9609   e2 96 89    &#x2589;   LEFT SEVEN EIGHTHS BLOCK
-- "█"  U+2588  9608   e2 96 88    &block;    FULL BLOCK [solid]
-- "│"  U+2502  9474   e2 94 82    &boxv;     BOX DRAWINGS LIGHT VERTICAL [Videotex Mosaic DG 14]
-- "┃"  U+2503  9475   e2 94 83    &#x2503;   BOX DRAWINGS HEAVY VERTICAL
-- "▕"  U+2595  9621   e2 96 95    &#x2595;   RIGHT ONE EIGHTH BLOCK
-- "▐"  U+2590  9616   e2 96 90    &#x2590;   RIGHT HALF BLOCK
-- "╎"  U+254E  9550   e2 95 8e    &#x254e;   BOX DRAWINGS LIGHT DOUBLE DASH VERTICAL
-- "╏"  U+254F  9551   e2 95 8f    &#x254f;   BOX DRAWINGS HEAVY DOUBLE DASH VERTICAL
-- "┆"  U+2506  9478   e2 94 86    &#x2506;   BOX DRAWINGS LIGHT TRIPLE DASH VERTICAL
-- "┇"  U+2507  9479   e2 94 87    &#x2507;   BOX DRAWINGS HEAVY TRIPLE DASH VERTICAL
-- "┊"  U+250A  9482   e2 94 8a    &#x250a;   BOX DRAWINGS LIGHT QUADRUPLE DASH VERTICAL
-- "┋"  U+250B  9483   e2 94 8b    &#x250b;   BOX DRAWINGS HEAVY QUADRUPLE DASH VERTICAL
-- "║"  U+2551  9553   e2 95 91    &boxV;     BOX DRAWINGS DOUBLE VERTICAL
-- ""  U+E0A0  57504  ee 82 a0    &#xe0a0;   <Private Use> Nerd Fonts nf-pl-branch
-- ""  U+E0A1  57505  ee 82 a1    &#xe0a1;   <Private Use> Nerd Fonts nf-pl-current_line nf-pl-line_number
-- ""  U+E0A2  57506  ee 82 a2    &#xe0a2;   <Private Use> Nerd Fonts nf-pl-readonly nf-pl-hostname
-- ""  U+E0B0  57520  ee 82 b0    &#xe0b0;   <Private Use> Nerd Fonts nf-pl-left_hard_divider
-- ""  U+E0B1  57521  ee 82 b1    &#xe0b1;   <Private Use> Nerd Fonts nf-pl-left_soft_divider
-- ""  U+E0B2  57522  ee 82 b2    &#xe0b2;   <Private Use> Nerd Fonts nf-pl-right_hard_divider
-- ""  U+E0B3  57523  ee 82 b3    &#xe0b3;   <Private Use> Nerd Fonts nf-pl-right_soft_divider
-- ""  U+F449  62537  ef 91 89    &#xf449;   <Private Use> Nerd Fonts nf-oct-info
-- ""  U+F400  62464  ef 90 80    &#xf400;   <Private Use> Nerd Fonts nf-oct-light_bulb

-- ### SUMMARY OF CUSTOM KEYMAPS ###

-- === Autocompletion ===
-- Ctrl-b     - scroll docs up
-- Ctrl-f     - scroll docs down
-- Ctrl-Space - complete symbol
-- Tab        - cycle over completions
-- Shift-Tab  - cycle back over completions
-- Ctrl-e     - abort completion
-- Enter      - accept completion
-- Ctrl-x     - complete using cmp_ai plugin

-- === LSP actions ===
-- gd - go to definition
-- gD - go to declaration
-- ge - put diagnostics into LocList
-- <Leader>-f - format buffer
-- ]g - go to next diagnostic
-- [g - go to prev diagnostic

-- default builtin LSP mappings since Neovim 0.12
-- gra - show other code actions
-- gri - go to implementation
-- grt - go to type definition
-- grr - list references
-- grn - rename symbol
-- grx - code lens
--  gO - document symbol
--  gx - textDocument/documentLink
--   K  - docs popup
-- Ctrl-S (insert mode) - signature documentation

-- === Trouble ===
-- <leader>xx - buffer diagnostics
-- <leader>xX - project diagnostics
-- <leader>cs - symbols
-- <leader>cl - LSP definitions / references
-- <leader>xL - Trouble Location List
-- <leader>xQ - Trouble QuickFix list

-- === Treesitter ===
-- works in VISUAL mode, copied from :help treesitter-incremental-selection
-- v_an select [count-th] parent node
-- v_an select [count-th] previous (or first) child node
-- v_]n select [count-th] next node
-- v_[n select [count-th] previous node

-- === Telescope ===
-- Ctrl-p - git_files
-- Ctrl-P - find_files
-- Ctrl-f f - live_grep - search for word with incremental live feedback
-- Ctrl-f n - grep_string - search for word under cursor (or selection)

-- === Other ===
-- F3 - toggle NerdTree file browser
-- F4 - toggle code structure outline sidebar
-- F5 - toggle between dark and light
-- Space - unhighlight search results in normal mode
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
