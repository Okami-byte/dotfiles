-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Change colon line key to semi colon
keymap.set("", ":", ";", { desc = "swap colon with semi colon" })
keymap.set("", ";", ":", { desc = "swap colon with semi colon" })

-- Moving windows
vim.keymap.set("n", "<leader><left>", ":vertical resize +20<cr>")
vim.keymap.set("n", "<leader><right>", ":vertical resize -20<cr>")
vim.keymap.set("n", "<leader><up>", ":resize +10<cr>")
vim.keymap.set("n", "<leader><down>", ":resize -10<cr>")

-- ############################################################################
--                         Begin of markdown section
-- ############################################################################

-- Mappings for creating new groups that don't exist
-- When I press leader, I want to modify the name of the options shown
-- "m" is for "markdown" and "t" is for "todo"
-- https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-mappings
local wk = require("which-key")
wk.add({
  -- {
  --   mode = { "n" },
  --   { "<leader>t", group = "[P]todo" },
  -- },
  {
    mode = { "n", "v" },
    { "<leader>m", group = "[P]markdown" },
    { "<leader>mf", group = "[P]fold" },
    { "<leader>mh", group = "[P]headings increase/decrease" },
    { "<leader>ml", group = "[P]links" },
    { "<leader>ms", group = "[P]spell" },
    { "<leader>msl", group = "[P]language" },
  },
})

-- In visual mode, delete all newlines within selected text
-- I like keeping my bulletpoints one after the next, sometimes formatting gets
-- in the way and they mess up, so this allows me to select all of them and just
-- delete newlines in between lamw25wmal
vim.keymap.set("v", "<leader>mj", function()
  -- Get the visual selection range
  local start_row = vim.fn.line("v")
  local end_row = vim.fn.line(".")
  -- Ensure start_row is less than or equal to end_row
  if start_row > end_row then
    start_row, end_row = end_row, start_row
  end
  -- Loop through each line in the selection
  local current_row = start_row
  while current_row <= end_row do
    local line = vim.api.nvim_buf_get_lines(0, current_row - 1, current_row, false)[1]
    -- vim.notify("Checking line " .. current_row .. ": " .. (line or ""), vim.log.levels.INFO)
    -- If the line is empty, delete it and adjust end_row
    if line == "" then
      vim.cmd(current_row .. "delete")
      end_row = end_row - 1
    else
      current_row = current_row + 1
    end
  end
end, { desc = "[P]Delete newlines in selected text (join)" })

-- Toggle bullet point at the beginning of the current line in normal mode
-- If in a multiline paragraph, make sure the cursor is on the line at the top
-- "d" is for "dash" lamw25wmal
vim.keymap.set("n", "<leader>md", function()
  -- Get the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_buffer = vim.api.nvim_get_current_buf()
  local start_row = cursor_pos[1] - 1
  local col = cursor_pos[2]
  -- Get the current line
  local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]
  -- Check if the line already starts with a bullet point
  if line:match("^%s*%-") then
    -- Remove the bullet point from the start of the line
    line = line:gsub("^%s*%-", "")
    vim.api.nvim_buf_set_lines(current_buffer, start_row, start_row + 1, false, { line })
    return
  end
  -- Search for newline to the left of the cursor position
  local left_text = line:sub(1, col)
  local bullet_start = left_text:reverse():find("\n")
  if bullet_start then
    bullet_start = col - bullet_start
  end
  -- Search for newline to the right of the cursor position and in following lines
  local right_text = line:sub(col + 1)
  local bullet_end = right_text:find("\n")
  local end_row = start_row
  while not bullet_end and end_row < vim.api.nvim_buf_line_count(current_buffer) - 1 do
    end_row = end_row + 1
    local next_line = vim.api.nvim_buf_get_lines(current_buffer, end_row, end_row + 1, false)[1]
    if next_line == "" then
      break
    end
    right_text = right_text .. "\n" .. next_line
    bullet_end = right_text:find("\n")
  end
  if bullet_end then
    bullet_end = col + bullet_end
  end
  -- Extract lines
  local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, end_row + 1, false)
  local text = table.concat(text_lines, "\n")
  -- Add bullet point at the start of the text
  local new_text = "- " .. text
  local new_lines = vim.split(new_text, "\n")
  -- Set new lines in buffer
  vim.api.nvim_buf_set_lines(current_buffer, start_row, end_row + 1, false, new_lines)
end, { desc = "[P]Toggle bullet point (dash)" })

-- -- Toggle bullet point at the beginning of the current line in normal mode
-- vim.keymap.set("n", "<leader>ml", function()
--   -- Notify that the function is being executed
--   vim.notify("Executing bullet point toggle function", vim.log.levels.INFO)
--   -- Get the current cursor position
--   local cursor_pos = vim.api.nvim_win_get_cursor(0)
--   vim.notify("Cursor position: row " .. cursor_pos[1] .. ", col " .. cursor_pos[2], vim.log.levels.INFO)
--   local current_buffer = vim.api.nvim_get_current_buf()
--   local row = cursor_pos[1] - 1
--   -- Get the current line
--   local line = vim.api.nvim_buf_get_lines(current_buffer, row, row + 1, false)[1]
--   vim.notify("Current line: " .. line, vim.log.levels.INFO)
--   if line:match("^%s*%-") then
--     -- If the line already starts with a bullet point, remove it
--     vim.notify("Bullet point detected, removing it", vim.log.levels.INFO)
--     line = line:gsub("^%s*%-", "", 1)
--     vim.api.nvim_buf_set_lines(current_buffer, row, row + 1, false, { line })
--   else
--     -- Otherwise, delete the line, add a bullet point, and paste the text
--     vim.notify("No bullet point detected, adding it", vim.log.levels.INFO)
--     line = "- " .. line
--     vim.api.nvim_buf_set_lines(current_buffer, row, row + 1, false, { line })
--   end
-- end, { desc = "Toggle bullet point at the beginning of the current line" })

-- Show spelling suggestions / spell suggestions
vim.keymap.set("n", "<leader>mss", function()
  -- Simulate pressing "z=" with "m" option using feedkeys
  -- vim.api.nvim_replace_termcodes ensures "z=" is correctly interpreted
  -- 'm' is the {mode}, which in this case is 'Remap keys'. This is default.
  -- If {mode} is absent, keys are remapped.
  --
  -- I tried this keymap as usually with
  vim.cmd("normal! 1z=")
  -- But didn't work, only with nvim_feedkeys
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("z=", true, false, true), "m", true)
end, { desc = "[P]Spelling suggestions" })

-- markdown good, accept spell suggestion
-- Add word under the cursor as a good word
vim.keymap.set("n", "<leader>msg", function()
  vim.cmd("normal! zg")
end, { desc = "[P]Spelling add word to spellfile" })

-- Undo zw, remove the word from the entry in 'spellfile'.
vim.keymap.set("n", "<leader>msu", function()
  vim.cmd("normal! zug")
end, { desc = "[P]Spelling undo, remove word from list" })

-- Repeat the replacement done by |z=| for all matches with the replaced word
-- in the current window.
vim.keymap.set("n", "<leader>msr", function()
  -- vim.cmd(":spellr")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":spellr\n", true, false, true), "m", true)
end, { desc = "[P]Spelling repeat" })

-- In visual mode, check if the selected text is already bold and show a message if it is
-- If not, surround it with double asterisks for bold
vim.keymap.set("v", "<leader>mb", function()
  -- Get the selected text range
  local start_row, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
  local end_row, end_col = unpack(vim.fn.getpos("'>"), 2, 3)
  -- Get the selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local selected_text = table.concat(lines, "\n"):sub(start_col, #lines == 1 and end_col or -1)
  if selected_text:match("^%*%*.*%*%*$") then
    vim.notify("Text already bold", vim.log.levels.INFO)
  else
    vim.cmd("normal 2gsa*")
  end
end, { desc = "[P]BOLD current selection" })

-- Using keymaps to do terraform functions
vim.keymap.set("n", "<leader>ti", ":terraform init<CR>")
vim.keymap.set("n", "<leader>tv", ":terraform validate<CR>")
vim.keymap.set("n", "<leader>tp", ":terraform plan<CR>")
vim.keymap.set("n", "<leader>taa", ":terraform apply -auto-approve<CR>")

-- Multiline unbold attempt
-- In normal mode, bold the current word under the cursor
-- If already bold, it will unbold the word under the cursor
-- If you're in a multiline bold, it will unbold it only if you're on the
-- first line
vim.keymap.set("n", "<leader>mb", function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_buffer = vim.api.nvim_get_current_buf()
  local start_row = cursor_pos[1] - 1
  local col = cursor_pos[2]
  -- Get the current line
  local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]
  -- Check if the cursor is on an asterisk
  if line:sub(col + 1, col + 1):match("%*") then
    vim.notify("Cursor is on an asterisk, run inside the bold text", vim.log.levels.WARN)
    return
  end
  -- Search for '**' to the left of the cursor position
  local left_text = line:sub(1, col)
  local bold_start = left_text:reverse():find("%*%*")
  if bold_start then
    bold_start = col - bold_start
  end
  -- Search for '**' to the right of the cursor position and in following lines
  local right_text = line:sub(col + 1)
  local bold_end = right_text:find("%*%*")
  local end_row = start_row
  while not bold_end and end_row < vim.api.nvim_buf_line_count(current_buffer) - 1 do
    end_row = end_row + 1
    local next_line = vim.api.nvim_buf_get_lines(current_buffer, end_row, end_row + 1, false)[1]
    if next_line == "" then
      break
    end
    right_text = right_text .. "\n" .. next_line
    bold_end = right_text:find("%*%*")
  end
  if bold_end then
    bold_end = col + bold_end
  end
  -- Remove '**' markers if found, otherwise bold the word
  if bold_start and bold_end then
    -- Extract lines
    local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, end_row + 1, false)
    local text = table.concat(text_lines, "\n")
    -- Calculate positions to correctly remove '**'
    -- vim.notify("bold_start: " .. bold_start .. ", bold_end: " .. bold_end)
    local new_text = text:sub(1, bold_start - 1) .. text:sub(bold_start + 2, bold_end - 1) .. text:sub(bold_end + 2)
    local new_lines = vim.split(new_text, "\n")
    -- Set new lines in buffer
    vim.api.nvim_buf_set_lines(current_buffer, start_row, end_row + 1, false, new_lines)
    -- vim.notify("Unbolded text", vim.log.levels.INFO)
  else
    -- Bold the word at the cursor position if no bold markers are found
    local before = line:sub(1, col)
    local after = line:sub(col + 1)
    local inside_surround = before:match("%*%*[^%*]*$") and after:match("^[^%*]*%*%*")
    if inside_surround then
      vim.cmd("normal gsd*.")
    else
      vim.cmd("normal viw")
      vim.cmd("normal 2gsa*")
    end
    vim.notify("Bolded current word", vim.log.levels.INFO)
  end
end, { desc = "[P]BOLD toggle bold markers" })

-- -- Single word/line bold
-- -- In normal mode, bold the current word under the cursor
-- -- If already bold, it will unbold the word under the cursor
-- -- This does NOT unbold multilines
-- vim.keymap.set("n", "<leader>mb", function()
--   local cursor_pos = vim.api.nvim_win_get_cursor(0)
--   -- local row = cursor_pos[1] -- Removed the unused variable
--   local col = cursor_pos[2]
--   local line = vim.api.nvim_get_current_line()
--   -- Check if the cursor is on an asterisk
--   if line:sub(col + 1, col + 1):match("%*") then
--     vim.notify("Cursor is on an asterisk, run inside the bold text", vim.log.levels.WARN)
--     return
--   end
--   -- Check if the cursor is inside surrounded text
--   local before = line:sub(1, col)
--   local after = line:sub(col + 1)
--   local inside_surround = before:match("%*%*[^%*]*$") and after:match("^[^%*]*%*%*")
--   if inside_surround then
--     vim.cmd("normal gsd*.")
--   else
--     vim.cmd("normal viw")
--     vim.cmd("normal 2gsa*")
--   end
-- end, { desc = "[P]BOLD toggle on current word or selection" })

-- In visual mode, surround the selected text with markdown link syntax
vim.keymap.set("v", "<leader>mll", function()
  -- Copy what's currently in my clipboard to the register "a lamw25wmal
  vim.cmd("let @a = getreg('+')")
  -- delete selected text
  vim.cmd("normal d")
  -- Insert the following in insert mode
  vim.cmd("startinsert")
  vim.api.nvim_put({ "[]() " }, "c", true, true)
  -- Move to the left, paste, and then move to the right
  vim.cmd("normal F[pf(")
  -- Copy what's on the "a register back to the clipboard
  vim.cmd("call setreg('+', @a)")
  -- Paste what's on the clipboard
  vim.cmd("normal p")
  -- Leave me in normal mode or command mode
  vim.cmd("stopinsert")
  -- Leave me in insert mode to start typing
  -- vim.cmd("startinsert")
end, { desc = "[P]Convert to link" })

-- In visual mode, surround the selected text with markdown link syntax
vim.keymap.set("v", "<leader>mlt", function()
  -- Copy what's currently in my clipboard to the register "a lamw25wmal
  vim.cmd("let @a = getreg('+')")
  -- delete selected text
  vim.cmd("normal d")
  -- Insert the following in insert mode
  vim.cmd("startinsert")
  vim.api.nvim_put({ '[](){:target="_blank"} ' }, "c", true, true)
  vim.cmd("normal F[pf(")
  -- Copy what's on the "a register back to the clipboard
  vim.cmd("call setreg('+', @a)")
  -- Paste what's on the clipboard
  vim.cmd("normal p")
  -- Leave me in normal mode or command mode
  vim.cmd("stopinsert")
  -- Leave me in insert mode to start typing
  -- vim.cmd("startinsert")
end, { desc = "[P]Convert to link (new tab)" })

-- Paste a github link and add it in this format
-- [folke/noice.nvim](https://github.com/folke/noice.nvim){:target="\_blank"}
vim.keymap.set("i", "<C-g>", function()
  -- Insert the text in the desired format
  vim.cmd('normal! a[](){:target="_blank"} ')
  vim.cmd("normal! F(pv2F/lyF[p")
  -- Leave me in normal mode or command mode
  vim.cmd("stopinsert")
end, { desc = "[P]Paste Github link" })

-- -- The following are related to indentation with tab, may not work perfectly
-- -- but get the job done
-- -- To indent in insert mode use C-T and C-D and in normal mode >> and <<
-- --
-- -- I disabled these as they interfere when jumpting to different sections of
-- -- my snippets, and probably other stuff, not a good idea
-- -- Maybe look for a different key, but not tab
-- --
-- -- Increase indent with tab in normal mode
-- vim.keymap.set("n", "<Tab>", function()
--   vim.cmd("normal >>")
-- end, { desc = "[P]Increase Indent" })
--
-- -- Decrease indent with tab in normal mode
-- vim.keymap.set("n", "<S-Tab>", function()
--   vim.cmd("normal <<")
-- end, { desc = "[P]Decrease Indent" })
--
-- -- Increase indent with tab in insert mode
-- vim.keymap.set("i", "<Tab>", function()
--   vim.api.nvim_input("<C-T>")
-- end, { desc = "[P]Increase Indent" })
--
-- -- Decrease indent with tab in insert mode
-- vim.keymap.set("i", "<S-Tab>", function()
--   vim.api.nvim_input("<C-D>")
-- end, { desc = "[P]Decrease Indent" })

-------------------------------------------------------------------------------
--                           Folding section
-------------------------------------------------------------------------------

-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set("n", "<CR>", function()
  -- Get the current line number
  local line = vim.fn.line(".")
  -- Get the fold level of the current line
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
  end
end, { desc = "[P]Toggle fold" })

local function set_foldmethod_expr()
  -- These are lazyvim.org defaults but setting them just in case a file
  -- doesn't have them set
  if vim.fn.has("nvim-0.10") == 1 then
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
    vim.opt.foldtext = ""
  else
    vim.opt.foldmethod = "indent"
    vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
  end
  vim.opt.foldlevel = 99
end

-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
  -- Move to the top of the file
  vim.cmd("normal! gg")
  -- Get the total number of lines
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    -- "^" -> Ensures the match is at the start of the line
    -- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
    -- "%s" -> Matches any whitespace character after the "#" characters
    -- So this will match `## `, `### `, `#### ` for example, which are markdown headings
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      -- Move the cursor to the current line
      vim.fn.cursor(line, 1)
      -- Fold the heading if it matches the level
      if vim.fn.foldclosed(line) == -1 then
        vim.cmd("normal! za")
      end
    end
  end
end

local function fold_markdown_headings(levels)
  set_foldmethod_expr()
  -- I save the view to know where to jump back after folding
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  -- Restore the view to jump to where I was
  vim.fn.winrestview(saved_view)
end

-- Keymap for unfolding markdown headings of level 2 or above
vim.keymap.set("n", "<leader>mfu", function()
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  vim.cmd("normal! zR") -- Unfold all headings
end, { desc = "[P]Unfold all headings level 2 or above" })

-- Keymap for folding markdown headings of level 1 or above
vim.keymap.set("n", "<leader>mfj", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
end, { desc = "[P]Fold all headings level 1 or above" })

-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
vim.keymap.set("n", "<leader>mfk", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
end, { desc = "[P]Fold all headings level 2 or above" })

-- Keymap for folding markdown headings of level 3 or above
vim.keymap.set("n", "<leader>mfl", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
end, { desc = "[P]Fold all headings level 3 or above" })

-- Keymap for folding markdown headings of level 4 or above
vim.keymap.set("n", "<leader>mf;", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
end, { desc = "[P]Fold all headings level 4 or above" })

-------------------------------------------------------------------------------
--                         End Folding section
-------------------------------------------------------------------------------
-- Detect todos and toggle between ":" and ";", or show a message if not found
-- This is to "mark them as done"
-- vim.keymap.set("n", "<leader>td", function()
--   -- Get the current line
--   local current_line = vim.fn.getline(".")
--   -- Get the current line number
--   local line_number = vim.fn.line(".")
--   if string.find(current_line, "TODO:") then
--     -- Replace the first occurrence of ":" with ";"
--     local new_line = current_line:gsub("TODO:", "TODO;")
--     -- Set the modified line
--     vim.fn.setline(line_number, new_line)
--   elseif string.find(current_line, "TODO;") then
--     -- Replace the first occurrence of ";" with ":"
--     local new_line = current_line:gsub("TODO;", "TODO:")
--     -- Set the modified line
--     vim.fn.setline(line_number, new_line)
--   else
--     vim.cmd("echo 'todo item not detected'")
--   end
-- end, { desc = "[P]TODO toggle item done or not" })

-- HACK: Create table of contents in neovim with markdown-toc
-- https://youtu.be/BVyrXsZ_ViA
--
-- Generate/update a Markdown TOC
-- To generate the TOC I use the markdown-toc plugin
-- https://github.com/jonschlinkert/markdown-toc
-- And the markdown-toc plugin installed as a LazyExtra
-- Function to update the Markdown TOC with customizable headings
local function update_markdown_toc(heading2, heading3)
  local path = vim.fn.expand("%") -- Expands the current file name to a full path
  local bufnr = 0 -- The current buffer number, 0 references the current active buffer
  -- Save the current view
  -- If I don't do this, my folds are lost when I run this keymap
  vim.cmd("mkview")
  -- Retrieves all lines from the current buffer
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local toc_exists = false -- Flag to check if TOC marker exists
  local frontmatter_end = 0 -- To store the end line number of frontmatter
  -- Check for frontmatter and TOC marker
  for i, line in ipairs(lines) do
    if i == 1 and line:match("^---$") then
      -- Frontmatter start detected, now find the end
      for j = i + 1, #lines do
        if lines[j]:match("^---$") then
          frontmatter_end = j
          break
        end
      end
    end
    -- Checks for the TOC marker
    if line:match("^%s*<!%-%-%s*toc%s*%-%->%s*$") then
      toc_exists = true
      break
    end
  end
  -- Inserts H2 and H3 headings and <!-- toc --> at the appropriate position
  if not toc_exists then
    local insertion_line = 1 -- Default insertion point after first line
    if frontmatter_end > 0 then
      -- Find H1 after frontmatter
      for i = frontmatter_end + 1, #lines do
        if lines[i]:match("^#%s+") then
          insertion_line = i + 1
          break
        end
      end
    else
      -- Find H1 from the beginning
      for i, line in ipairs(lines) do
        if line:match("^#%s+") then
          insertion_line = i + 1
          break
        end
      end
    end
    -- Insert the specified headings and <!-- toc --> without blank lines
    -- Insert the TOC inside a H2 and H3 heading right below the main H1 at the top lamw25wmal
    vim.api.nvim_buf_set_lines(bufnr, insertion_line, insertion_line, false, { heading2, heading3, "<!-- toc -->" })
  end
  -- Silently save the file, in case TOC is being created for the first time
  vim.cmd("silent write")
  -- Silently run markdown-toc to update the TOC without displaying command output
  -- vim.fn.system("markdown-toc -i " .. path)
  -- I want my bulletpoints to be created only as "-" so passing that option as
  -- an argument according to the docs
  -- https://github.com/jonschlinkert/markdown-toc?tab=readme-ov-file#optionsbullets
  vim.fn.system('markdown-toc --bullets "-" -i ' .. path)
  vim.cmd("edit!") -- Reloads the file to reflect the changes made by markdown-toc
  vim.cmd("silent write") -- Silently save the file
  vim.notify("TOC updated and file saved", vim.log.levels.INFO)
  -- -- In case a cleanup is needed, leaving this old code here as a reference
  -- -- I used this code before I implemented the frontmatter check
  -- -- Moves the cursor to the top of the file
  -- vim.api.nvim_win_set_cursor(bufnr, { 1, 0 })
  -- -- Deletes leading blank lines from the top of the file
  -- while true do
  --   -- Retrieves the first line of the buffer
  --   local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
  --   -- Checks if the line is empty
  --   if line == "" then
  --     -- Deletes the line if it's empty
  --     vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, {})
  --   else
  --     -- Breaks the loop if the line is not empty, indicating content or TOC marker
  --     break
  --   end
  -- end
  -- Restore the saved view (including folds)
  vim.cmd("loadview")
end

-- HACK: Create table of contents in neovim with markdown-toc
-- https://youtu.be/BVyrXsZ_ViA
--
-- Keymap for English TOC
vim.keymap.set("n", "<leader>mt", function()
  update_markdown_toc("## Contents", "### Table of contents")
end, { desc = "[P]Insert/update Markdown TOC (English)" })

-- Save the cursor position globally to access it across different mappings
_G.saved_positions = {}

-- Mapping to jump to the first line of the TOC
vim.keymap.set("n", "<leader>mm", function()
  -- Save the current cursor position
  _G.saved_positions["toc_return"] = vim.api.nvim_win_get_cursor(0)
  -- Perform a silent search for the <!-- toc --> marker and move the cursor two lines below it
  vim.cmd("silent! /<!-- toc -->\\n\\n\\zs.*")
  -- Clear the search highlight without showing the "search hit BOTTOM, continuing at TOP" message
  vim.cmd("nohlsearch")
  -- Retrieve the current cursor position (after moving to the TOC)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row = cursor_pos[1]
  -- local col = cursor_pos[2]
  -- Move the cursor to column 15 (starts counting at 0)
  -- I like just going down on the TOC and press gd to go to a section
  vim.api.nvim_win_set_cursor(0, { row, 14 })
end, { desc = "[P]Jump to the first line of the TOC" })

-- Mapping to return to the previously saved cursor position
vim.keymap.set("n", "<leader>mn", function()
  local pos = _G.saved_positions["toc_return"]
  if pos then
    vim.api.nvim_win_set_cursor(0, pos)
  end
end, { desc = "[P]Return to position before jumping" })

-- ############################################################################
--                             Image section
-- ############################################################################

-- HACK: View and paste images in Neovim like in Obsidian
-- https://youtu.be/0O3kqGwNzTI
--
-- Paste images
-- I tried using <C-v> but duh, that's used for visual block mode
-- vim.keymap.set({ "n", "i" }, "<M-a>", function()
vim.keymap.set({ "n", "i" }, "<leader>iv", function()
  local pasted_image = require("img-clip").paste_image()
  if pasted_image then
    -- "Update" saves only if the buffer has been modified since the last save
    vim.cmd("silent! update")
    -- Get the current line
    local line = vim.api.nvim_get_current_line()
    -- Move cursor to end of line
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], #line })
    -- I reload the file, otherwise I cannot view the image after pasted
    vim.cmd("edit!")
  end
end, { desc = "[P]Paste image from system clipboard" })

-------------------------------------------------------------------------------
--                       Assets directory
-------------------------------------------------------------------------------

-- NOTE: Configuration for image storage path
-- Change this to customize where images are stored relative to the assets directory
-- If below you use "img/imgs", it will store in "assets/img/imgs"
-- Added option to choose image format and resolution lamw26wmal
local IMAGE_STORAGE_PATH = "~/Notes-Vault/99 - Meta/assets/imgs"

-- This function is used in 2 places in the paste images in assets dir section
-- finds the assets/img/imgs directory going one dir at a time and returns the full path
local function find_assets_dir()
  local dir = vim.fn.expand("%:p:h")
  while dir ~= "/" do
    local full_path = dir .. "/assets/" .. IMAGE_STORAGE_PATH
    if vim.fn.isdirectory(full_path) == 1 then
      return full_path
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return nil
end

-- Since I need to store these images in a different directory, I pass the options to img-clip
local function handle_image_paste(img_dir)
  local function paste_image(dir_path, file_name, ext, cmd)
    return require("img-clip").paste_image({
      dir_path = dir_path,
      use_absolute_path = false,
      relative_to_current_file = false,
      file_name = file_name,
      extension = ext or "avif",
      process_cmd = cmd or "convert - -quality 75 avif:-",
    })
  end
  local temp_buf = vim.api.nvim_create_buf(false, true) -- Create an unlisted, scratch buffer
  vim.api.nvim_set_current_buf(temp_buf) -- Switch to the temporary buffer
  local temp_image_path = vim.fn.tempname() .. ".avif"
  local image_pasted =
    paste_image(vim.fn.fnamemodify(temp_image_path, ":h"), vim.fn.fnamemodify(temp_image_path, ":t:r"))
  vim.api.nvim_buf_delete(temp_buf, { force = true }) -- Delete the buffer
  vim.fn.delete(temp_image_path) -- Delete the temporary file
  vim.defer_fn(function()
    local options = image_pasted and { "no", "yes", "format", "search" } or { "search" }
    local prompt = image_pasted and "Is this a thumbnail image? " or "No image in clipboard. Select search to continue."
    -- -- I was getting a character in the textbox, don't want to debug right now
    -- vim.cmd("stopinsert")
    vim.ui.select(options, { prompt = prompt }, function(is_thumbnail)
      if is_thumbnail == "search" then
        local assets_dir = find_assets_dir()
        -- Get the parent directory of the current file
        local current_dir = vim.fn.expand("%:p:h")
        -- remove warning: Cannot assign `string|nil` to parameter `string`
        if not assets_dir then
          print("Assets directory not found, cannot proceed with search.")
          return
        end
        -- Get the parent directory of assets_dir (removing /img/imgs)
        local base_assets_dir = vim.fn.fnamemodify(assets_dir, ":h:h:h")
        -- Count how many levels we need to go up
        local levels = 0
        local temp_dir = current_dir
        while temp_dir ~= base_assets_dir and temp_dir ~= "/" do
          levels = levels + 1
          temp_dir = vim.fn.fnamemodify(temp_dir, ":h")
        end
        -- Build the relative path
        local relative_path = levels == 0 and "./assets/" .. IMAGE_STORAGE_PATH
          or string.rep("../", levels) .. "assets/" .. IMAGE_STORAGE_PATH
        vim.api.nvim_put({ "![Image](" .. relative_path .. '){: width="500" }' }, "c", true, true)
        -- Capital "O" to move to the line above
        vim.cmd("normal! O")
        -- This "o" is to leave a blank line above
        vim.cmd("normal! o")
        vim.api.nvim_put({ "<!-- prettier-ignore -->" }, "c", true, true)
        vim.cmd("normal! jo")
        vim.api.nvim_put({ "_textimage_", "" }, "c", true, true)
        -- find image path and add a / at the end of it
        vim.cmd("normal! kkf)i/")
        -- Move one to the right and enter insert mode
        vim.cmd("normal! la")
        -- -- This puts me in insert mode where the cursor is
        -- vim.api.nvim_feedkeys("i", "n", true)
        require("auto-save").on()
        return
      end
      if not is_thumbnail then
        print("Image pasting canceled.")
        require("auto-save").on()
        return
      end
      if is_thumbnail == "format" then
        local extension_options = { "avif", "webp", "png", "jpg" }
        vim.ui.select(extension_options, {
          prompt = "Select image format:",
          default = "avif",
        }, function(selected_ext)
          if not selected_ext then
            return
          end
          -- Define proceed_with_paste with proper parameter names
          local function proceed_with_paste(process_command)
            local prefix = vim.fn.strftime("%y%m%d-")
            local function prompt_for_name()
              vim.ui.input({ prompt = "Enter image name (no spaces). Added prefix: " .. prefix }, function(input_name)
                if not input_name or input_name:match("%s") then
                  print("Invalid image name or canceled. Image not pasted.")
                  require("auto-save").on()
                  return
                end
                local full_image_name = prefix .. input_name
                local file_path = img_dir .. "/" .. full_image_name .. "." .. selected_ext
                if vim.fn.filereadable(file_path) == 1 then
                  print("Image name already exists. Please enter a new name.")
                  prompt_for_name()
                else
                  if paste_image(img_dir, full_image_name, selected_ext, process_command) then
                    vim.api.nvim_put({ '{: width="500" }' }, "c", true, true)
                    vim.cmd("normal! O")
                    vim.cmd("stopinsert")
                    vim.cmd("normal! o")
                    vim.api.nvim_put({ "<!-- prettier-ignore -->" }, "c", true, true)
                    vim.cmd("normal! j$o")
                    vim.cmd("stopinsert")
                    vim.api.nvim_put({ "__" }, "c", true, true)
                    vim.cmd("normal! h")
                    vim.cmd("silent! update")
                    vim.cmd("edit!")
                  else
                    print("No image pasted. File not updated.")
                    require("auto-save").on()
                  end
                end
              end)
            end
            prompt_for_name()
          end
          -- Resolution prompt handling
          vim.ui.select({ "Yes", "No" }, {
            prompt = "Change image resolution?",
            default = "No",
          }, function(resize_choice)
            local process_cmd
            if resize_choice == "Yes" then
              vim.ui.input({
                prompt = "Enter max height (default 1080): ",
                default = "1080",
              }, function(height_input)
                local height = tonumber(height_input) or 1080
                process_cmd = string.format("convert - -resize x%d -quality 100 %s:-", height, selected_ext)
                proceed_with_paste(process_cmd)
              end)
            else
              process_cmd = "convert - -quality 75 " .. selected_ext .. ":-"
              proceed_with_paste(process_cmd)
            end
          end)
        end)
        return
      end
      local prefix = vim.fn.strftime("%y%m%d-") .. (is_thumbnail == "yes" and "thux-" or "")
      local function prompt_for_name()
        vim.ui.input({ prompt = "Enter image name (no spaces). Added prefix: " .. prefix }, function(input_name)
          if not input_name or input_name:match("%s") then
            print("Invalid image name or canceled. Image not pasted.")
            require("auto-save").on()
            return
          end
          local full_image_name = prefix .. input_name
          local file_path = img_dir .. "/" .. full_image_name .. ".avif"
          if vim.fn.filereadable(file_path) == 1 then
            print("Image name already exists. Please enter a new name.")
            prompt_for_name()
          else
            if paste_image(img_dir, full_image_name) then
              vim.api.nvim_put({ '{: width="500" }' }, "c", true, true)
              -- Create new line above and force normal mode
              vim.cmd("normal! O")
              vim.cmd("stopinsert") -- Explicitly exit insert mode
              -- Create blank line above and force normal mode
              vim.cmd("normal! o")
              vim.cmd("stopinsert")
              vim.api.nvim_put({ "<!-- prettier-ignore -->" }, "c", true, true)
              -- Move down and create new line (without staying in insert mode)
              vim.cmd("normal! j$o")
              vim.cmd("stopinsert")
              vim.api.nvim_put({ "__" }, "c", true, true)
              vim.cmd("normal! h") -- Position cursor between underscores
              vim.cmd("silent! update")
              vim.cmd("edit!")
            else
              print("No image pasted. File not updated.")
              require("auto-save").on()
            end
          end
        end)
      end
      prompt_for_name()
    end)
  end, 100)
end

local function process_image()
  -- Any of these 2 work to toggle auto-save
  -- vim.cmd("ASToggle")
  require("auto-save").off()
  local img_dir = find_assets_dir()
  if not img_dir then
    vim.ui.select({ "yes", "no" }, {
      prompt = IMAGE_STORAGE_PATH .. " directory not found. Create it?",
      default = "yes",
    }, function(choice)
      if choice == "yes" then
        img_dir = vim.fn.getcwd() .. "/assets/" .. IMAGE_STORAGE_PATH
        vim.fn.mkdir(img_dir, "p")
        -- Start the image paste process after creating directory
        vim.defer_fn(function()
          handle_image_paste(img_dir)
        end, 100)
      else
        print("Operation cancelled - directory not created")
        require("auto-save").on()
        return
      end
    end)
    return
  end
  handle_image_paste(img_dir)
end

-- Keymap to paste images in the 'assets' directory
-- This pastes images for my blogpost, I need to keep them in a different directory
-- so I pass those options to img-clip
vim.keymap.set({ "n", "i" }, "<M-1>", process_image, { desc = "[P]Paste image 'assets' directory" })

-------------------------------------------------------------------------------

-- Rename image under cursor lamw25wmal
-- If the image is referenced multiple times in the file, it will also rename
-- all the other occurrences in the file
vim.keymap.set("n", "<leader>iR", function()
  local function get_image_path()
    -- Get the current line
    local line = vim.api.nvim_get_current_line()
    -- Pattern to match image path in Markdown
    local image_pattern = "%[.-%]%((.-)%)"
    -- Extract relative image path
    local _, _, image_path = string.find(line, image_pattern)
    return image_path
  end
  -- Get the image path
  local image_path = get_image_path()
  if not image_path then
    vim.api.nvim_echo({ { "No image found under the cursor", "WarningMsg" } }, false, {})
    return
  end
  -- Check if it's a URL
  if string.sub(image_path, 1, 4) == "http" then
    vim.api.nvim_echo({ { "URL images cannot be renamed.", "WarningMsg" } }, false, {})
    return
  end
  -- Get absolute paths
  local current_file_path = vim.fn.expand("%:p:h")
  local absolute_image_path = current_file_path .. "/" .. image_path
  -- Check if file exists
  if vim.fn.filereadable(absolute_image_path) == 0 then
    vim.api.nvim_echo(
      { { "Image file does not exist:\n", "ErrorMsg" }, { absolute_image_path, "ErrorMsg" } },
      false,
      {}
    )
    return
  end
  -- Get directory and extension of current image
  local dir = vim.fn.fnamemodify(absolute_image_path, ":h")
  local ext = vim.fn.fnamemodify(absolute_image_path, ":e")
  local current_name = vim.fn.fnamemodify(absolute_image_path, ":t:r")
  -- Prompt for new name
  vim.ui.input({ prompt = "Enter new name (without extension): ", default = current_name }, function(new_name)
    if not new_name or new_name == "" then
      vim.api.nvim_echo({ { "Rename cancelled", "WarningMsg" } }, false, {})
      return
    end
    -- Construct new path
    local new_absolute_path = dir .. "/" .. new_name .. "." .. ext
    -- Check if new filename already exists
    if vim.fn.filereadable(new_absolute_path) == 1 then
      vim.api.nvim_echo({ { "File already exists: " .. new_absolute_path, "ErrorMsg" } }, false, {})
      return
    end
    -- Rename the file
    local success, err = os.rename(absolute_image_path, new_absolute_path)
    if success then
      -- Get the old and new filenames (without path)
      local old_filename = vim.fn.fnamemodify(absolute_image_path, ":t")
      local new_filename = vim.fn.fnamemodify(new_absolute_path, ":t")
      -- -- Debug prints
      -- print("Old filename:", old_filename)
      -- print("New filename:", new_filename)
      -- Get buffer content
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      -- print("Number of lines in buffer:", #lines)
      -- Replace the text in each line that contains the old filename
      for i = 0, #lines - 1 do
        local line = lines[i + 1]
        -- First find the image markdown pattern with explicit end
        local img_start, img_end = line:find("!%[.-%]%(.-%)")
        if img_start and img_end then
          -- Get just the exact markdown part without any extras
          local markdown_part = line:match("!%[.-%]%(.-%)")
          -- Replace old filename with new filename
          local escaped_old = old_filename:gsub("[%-%.%+%[%]%(%)%$%^%%%?%*]", "%%%1")
          local escaped_new = new_filename:gsub("[%%]", "%%%%")
          -- Replace in the exact markdown part
          local new_markdown = markdown_part:gsub(escaped_old, escaped_new)
          -- Replace that exact portion in the line
          vim.api.nvim_buf_set_text(
            0,
            i,
            img_start - 1,
            i,
            img_start + #markdown_part - 1, -- Use exact length of markdown part
            { new_markdown }
          )
        end
      end
      -- "Update" saves only if the buffer has been modified since the last save
      vim.cmd("update")
      vim.api.nvim_echo({
        { "Image renamed successfully", "Normal" },
      }, false, {})
    else
      vim.api.nvim_echo({
        { "Failed to rename image:\n", "ErrorMsg" },
        { tostring(err), "ErrorMsg" },
      }, false, {})
    end
  end)
end, { desc = "[P]Rename image under cursor" })

-- ############################################################################

-- HACK: Upload images from Neovim to Imgur
-- https://youtu.be/Lzl_0SzbUBo
--
-- Open image under cursor in the Preview app (macOS)
vim.keymap.set("n", "<leader>io", function()
  local function get_image_path()
    -- Get the current line
    local line = vim.api.nvim_get_current_line()
    -- Pattern to match image path in Markdown
    local image_pattern = "%[.-%]%((.-)%)"
    -- Extract relative image path
    local _, _, image_path = string.find(line, image_pattern)
    return image_path
  end
  -- Get the image path
  local image_path = get_image_path()
  if image_path then
    -- Check if the image path starts with "http" or "https"
    if string.sub(image_path, 1, 4) == "http" then
      print("URL image, use 'gx' to open it in the default browser.")
    else
      -- Construct absolute image path
      local current_file_path = vim.fn.expand("%:p:h")
      local absolute_image_path = current_file_path .. "/" .. image_path
      -- Construct command to open image in Preview
      local command = "open -a Preview " .. vim.fn.shellescape(absolute_image_path)
      -- Execute the command
      local success = os.execute(command)
      if success then
        print("Opened image in Preview: " .. absolute_image_path)
      else
        print("Failed to open image in Preview: " .. absolute_image_path)
      end
    end
  else
    print("No image found under the cursor")
  end
end, { desc = "[P](macOS) Open image under cursor in Preview" })
