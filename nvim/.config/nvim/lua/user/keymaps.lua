vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function map(mode, lhs, rhs, desc, opts)
  local defaults = { silent = true, desc = desc or "" }
  opts = vim.tbl_deep_extend("force", defaults, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Allow remapping of <tab> separately from <C-i>
map("n", "<C-i>", "<C-i>", ":h CTRL-I")

--[[ Actively useful mappings ]]
-- ALT-{j,k} to move line(s) {up,down}, auto-indenting within blocks
map("n", "<M-j>", ":m +1<cr>==", "Move line down")
map("n", "<M-k>", ":m -2<cr>==", "Move line up")
map("i", "<M-j>", "<esc>:m +1<cr>==a", "Move line down")
map("i", "<M-k>", "<esc>:m -2<cr>==a", "Move line up")
map("v", "<M-j>", ":m '>+1<cr>gv=gv", "Move lines down")
map("v", "<M-k>", ":m '<-2<cr>gv=gv", "Move lines up")

-- Search and replace
map("n", "S", ":%s/<C-r><C-w>//gI<Left><Left><Left>", "Replace word under cursor", { silent = false })
map("n", "<M-S>", ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>", "Change word under cursor", { silent = false })
map("v", "S", '"ry:%s/<C-r><C-r>r//gI<Left><Left><Left>', "Replace selection", { silent = false })
map("v", "<M-S>", '"ry:%s/<C-r><C-r>r/<C-r><C-r>r/gI<Left><Left><Left>', "Change selection", { silent = false })

-- Manage interaction with system clipboard
map("", "<leader>y", '"+y', "Yank to system clipboard")
map("n", "<leader>p", '"+p', "Paste from system clipboard")
map("x", "<leader>p", '"_d"+P', "Paste from system clipboard over text without yanking")

-- Alternate paste/delete to avoid overwriting the default register
map("", "<M-c>", '"_c', "Change, deleting to void register")
map("", "<M-d>", '"_d', "Delete to void register")
map("", "<M-x>", '"_x', "Delete character to void register")
map("x", "<M-p>", '"_dP', "Paste over text without yanking it to the register")

--[[ Generally convenient mappings ]]
-- <C-BS> should function as expected
map("!", "<C-BS>", "<C-w>", "h: c_CTRL-W")

-- Undo break-points (close undo sequence, start new change)
map("i", ",", ",<C-g>u", "h: i_CTRL-G_u")
map("i", ".", ".<C-g>u", "h: i_CTRL-G_u")
map("i", ";", ";<C-g>u", "h: i_CTRL-G_u")
map("i", "<cr>", "<C-]><C-g>u<cr>", "h: i_CTRL-G_u")
map("i", "<C-BS>", "<C-g>u<C-w>", "h: i_CTRL-G_u")

-- Some write aliases
map("n", "<leader>w", "<cmd>write<cr>", "Write the current buffer")
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<cr>", "Write the current buffer")

-- Don't move cursor when joining lines
map({ "n", "v" }, "J", "mzJ`z", "Join lines")
map({ "n", "v" }, "gJ", "mzgJ`z", "Join lines")

-- Errors, diagnostics, etc.
map("n", "]e", "<cmd>cnext<cr>", "Next error")
map("n", "[e", "<cmd>cprev<cr>", "Previous error")
map("n", "]l", "<cmd>lnext<cr>", "Next location")
map("n", "[l", "<cmd>lprev<cr>", "Previous location")
map("n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic message")
map("n", "]d", vim.diagnostic.goto_next, "go to next diagnostic message")
map("n", "gl", vim.diagnostic.open_float, "open diagnostic float")
map("n", "gL", vim.diagnostic.setloclist, "Open diagnostics list")

-- Helpful when needed, though perhaps not needed too often
map("v", "<", "<gv", "Decrease indent")
map("v", ">", ">gv", "Increase indent")
map("n", "<F1>", ":help <C-r><C-w><cr>", "View help page for word under cursor")
map("v", "<F1>", '"hy:help <C-r>h<cr>', "View help page for selection")
map("n", "<leader><cr>", "<cmd>source<cr>", "Source the current buffer")
map("n", "<leader>x", "<cmd>!chmod +x %<cr>", "Make current file executable")

--[[ The mystical -- INSERT SELECT -- mode ]]
-- See https://old.reddit.com/r/vim/comments/jeryf8/wtf_is_insert_select_mode/
vim.cmd([[
fun! s:insert_select_mode()
  fun! s:select()
    call search('\<', 'b')
    " -- INSERT SELECT --
    normal! gh
    " -- INSERT VISUAL --
    " normal! v
    let g:mode = mode(1)
    call search('\>')
  endfun

  au CompleteDone <buffer> ++once call <SID>select()
  call complete(col('.'), ['foo', 'bar'])
  return ''
endfun

inoremap <C-X>? <C-R>=<SID>insert_select_mode()<CR>
]])
