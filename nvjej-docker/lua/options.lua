require "nvchad.options"

local o = vim.o

-------------------------------------- options ------------------------------------------

o.cursorlineopt = 'both'

-- Indenting
o.expandtab = false
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = true

-- UI
o.scrolloff = 8

-- Key mappings for setting the colorcolumn
vim.keymap.set("n", "<Leader>cc", ":set colorcolumn=80<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>ncc", ":set colorcolumn-=80<CR>", { noremap = true, silent = true })

local function insert_include_guard()
	-- Check if the current file is a .hpp file.
	if vim.fn.expand("%:e") ~= "hpp" then
		vim.notify("This is not a .hpp file.", vim.log.levels.WARN)
		return
	end

	-- Get the file name (e.g. "Default.class.hpp")
	local filename = vim.fn.expand("%:t")
	-- Remove the extension (.hpp)
	local base = filename:gsub("%.hpp$", "")
	-- Replace any dot with an underscore, then convert to uppercase and append _HPP.
	local guard = base:gsub("%.", "_"):upper() .. "_HPP"

	-- Calculate stars so that the final line is exactly 80 columns wide.
	-- Fixed parts: "#endif  // " (11 characters) + 1 space + " //" (3 characters) = 15.
	local stars_count = 80 - 15 - #guard
	local stars = string.rep("*", stars_count)

	-- Build the include guard template.
	local template = {
		"#ifndef " .. guard,
		"# define " .. guard,
		"", -- empty line between "# define" and "#endif"
		"#endif  // " .. stars .. " " .. guard .. " //",
	}

	-- Append the template at the end of the current buffer.
	local total = vim.fn.line("$")
	vim.api.nvim_buf_set_lines(0, total, total, false, template)

	-- Delete line 13 (if it exists) – note: buffer lines are 1-indexed,
	-- but nvim_buf_set_lines expects 0-indexed start/end, so line 13 is index 12.
	if vim.fn.line("$") >= 13 then
		vim.api.nvim_buf_set_lines(0, 12, 13, false, {})
	end

	-- Determine the target line for the cursor: line 15 if it exists; otherwise, the last line.
	local current_total = vim.fn.line("$")
	local target_line = (current_total >= 15) and 15 or current_total

	vim.api.nvim_win_set_cursor(0, { target_line, 0 })
	--  vim.cmd("startinsert")
end

-- Map F2 to call insert_include_guard() in normal mode.
vim.keymap.set("n", "<F2>", insert_include_guard, { noremap = true, silent = true })

local function insert_class_guard()
	-- Check if the current file is a .hpp file.
	if vim.fn.expand("%:e") ~= "hpp" then
		vim.notify("This is not a .hpp file.", vim.log.levels.WARN)
		return
	end

	-- Get the file name (e.g. "Default.class.hpp") and extract the base name.
	local filename = vim.fn.expand("%:t")
	local classname = filename:match("^[^.]+")

	-- Build the template using Allman formatting.
	local template = {
		"",
		"# include <iostream>",
		"",
		"class " .. classname,
		"{",
		"public:",
		"\t" .. classname .. "(void);",
		"\t" .. classname .. "(int const fooNb);",
		"\t" .. classname .. "(const " .. classname .. "& src);",
		"\t~" .. classname .. "(void);",
		"",
		"\t" .. classname .. "& operator=(const " .. classname .. "& rhs);",
		"",
		"\tint getFoo(void) const;",
		"\tstd::string toString(void) const; // serialise class to string",
		"",
		"private:",
		"\tint _foo;",
		"};",
		"",
		"// Overload operator<< for output streaming",
		"std::ostream & operator<<(std::ostream & out, const " .. classname .. "& in);",
	}

	-- Ensure the buffer has at least 15 lines.
	local total_lines = vim.fn.line("$")
	if total_lines < 15 then
		for _ = total_lines + 1, 15 do
			vim.api.nvim_buf_set_lines(0, -1, -1, false, { "" })
		end
	end

	-- Insert the template at line 15 (0-indexed line 14).
	vim.api.nvim_buf_set_lines(0, 14, 14, false, template)

	-- Move the cursor to the beginning of line 15 and enter insert mode.
	vim.api.nvim_win_set_cursor(0, { 15, 0 })
	--	vim.cmd("startinsert")
end

-- Map F3 to call insert_class_guard() in normal mode.
vim.keymap.set("n", "<F3>", insert_class_guard, { noremap = true, silent = true })

local function insert_class_functions_template()
	-- Check if the current file is a .cpp file.
	if vim.fn.expand("%:e") ~= "cpp" then
		vim.notify("This is not a .cpp file.", vim.log.levels.WARN)
		return
	end

	-- Get the file name (e.g. "Default.class.cpp") and extract the base name.
	local filename = vim.fn.expand("%:t")
	local classname = filename:match("^[^.]+")

	-- Build the template using Allman formatting.
	local template = {
		"",
		"# include <iostream>",
		"# include <ostream>",
		"# include <sstream>",
		"# include \"" .. classname .. ".class.hpp\"",
		"",
		classname .. "::" .. classname .. "(void)",
		": _foo(0)",
		"{",
		"\tstd::cout << \"Default constructor called\" << std::endl;",
		"\treturn;",
		"}",
		"",
		classname .. "::" .. classname .. "(int const fooNb)",
		": _foo(0)",
		"{",
		"\tstd::cout << \"Parametric constructor called\" << std::endl;",
		"\treturn;",
		"}",
		"",
		classname .. "::" .. classname .. "(const " .. classname .. "& src)",
		"{",
		"\tstd::cout << \"Copy constructor called\" << std::endl;",
		"\t*this = src;",
		"\treturn;",
		"}",
		"",
		classname .. "::~" .. classname .. "(void)",
		"{",
		"\tstd::cout << \"Destructor called\" << std::endl;",
		"\treturn;",
		"}",
		"",
		classname .. " & " .. classname .. "::operator=(const " .. classname .. "& rhs)",
		"{",
		"\tstd::cout << \"Assignment operator called\" << std::endl;",
		"\tif (this != &rhs)",
		"\t\tthis->_foo = rhs.getFoo();",
		"\treturn (*this);",
		"}",
		"",
		"std::ostream & operator<<(std::ostream & out, const " .. classname .. "& in)",
		"{",
		"\tout << \"The value of _foo is : \" << in.getFoo();",
		"\treturn (out);",
		"}",
		"",
		"int " .. classname .. "::getFoo(void) const { return (_foo); }",
		"",
		"std::string " .. classname .. "::toString(void) const",
		"{",
		"\tstd::ostringstream oss;",
		"\toss << \"" .. classname .. "(_foo=\" << _foo << \")\";",
		"\treturn (oss.str());",
		"}",
	}
	-- Ensure the buffer has at least 13 lines.
	local total_lines = vim.fn.line("$")
	if total_lines < 13 then
		for _ = total_lines + 1, 13 do
			vim.api.nvim_buf_set_lines(0, -1, -1, false, { "" })
		end
	end

	-- Insert the template at line 13 (0-indexed line 12).
	vim.api.nvim_buf_set_lines(0, 12, 12, false, template)

	-- Move the cursor to the beginning of line 13 and enter insert mode.
	vim.api.nvim_win_set_cursor(0, { 13, 0 })
	--	vim.cmd("startinsert")
end

-- Map F4 to call insert_class_functions_template() in normal mode.
vim.keymap.set("n", "<F4>", insert_class_functions_template, { noremap = true, silent = true })
