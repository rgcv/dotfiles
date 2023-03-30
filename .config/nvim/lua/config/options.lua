vim.g.mapleader = ","
vim.g.maplocalleader = " "

local opt = vim.opt

opt.autowrite = true -- Auto write in certain circumstances
opt.clipboard = "unnamedplus" -- Sync w/ system clipboard
opt.colorcolumn = "+1,120" -- Just after textwidth, hard cut at 120
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3 -- Fully conceal special markup
opt.confirm = true -- Confirm changes before exiting dirty buffer
opt.cursorline = true -- Highlight current line
opt.expandtab = true -- Use spaces vs. tabs
opt.formatoptions = "cjlnoqrt" -- default: tcqj
opt.ignorecase = true -- Ignore case in search patterns
opt.inccommand = "nosplit" -- Preview incremental substitute
opt.list = true -- Show invisible characters
opt.listchars = "tab:→ ,trail:-,space:·,nbsp:+"
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.path = (opt.path - ".") ^ { ".", "**" }
opt.pumblend = 10 -- Popup menu pseudo-transparency
opt.pumheight = 10 -- Max. number of items to show in the popup menu
opt.scrolloff = 4 -- Lines of context
opt.shiftround = true -- Round indents to multiples of 'shiftwidth'
opt.shiftwidth = 2 -- Size of an indent
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "number" -- Display signs in the 'number' column, otherwise auto
opt.smartcase = true -- Override ignorecase with uppercase
opt.smartindent = true -- Insert indents automatically
opt.splitbelow = true -- Split new windows below current
opt.splitright = true -- Split new windows to the right of current
opt.termguicolors = true -- True color support
opt.timeoutlen = 300 -- Time in ms for a mapped sequence to complete
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file sooner
opt.wrap = false -- Disable line wrapping
