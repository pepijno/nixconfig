require("luasnip.session.snippet_collection").clear_snippets "zig"

local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets('zig', {
	s("fn", fmt([[
	fn {}({}) {} {{
		{}
	}}
	]], { i(1), i(2), i(3), i(0) })),
	s("pubfn", fmt([[
	pub fn {}({}) {} {{
		{}
	}}
	]], { i(1), i(2), i(3), i(0) })),
	s("importstd", fmt([[const std = @import("std");
	]], {})),
	s("import", fmt([[const {} = @import("{}");
	]], { f(function(arg)
			local parts = vim.split(arg[1][1], "/", { plain = true })
			local last = parts[#parts] or ""
			if last ~= "" then
				vim.print(last)
				local file = vim.split(last, ".", { plain = true })[1] or ""
				return file
			else
				return last
			end
		end, { 1 }), i(1) })),
	s("stru", fmt([[
	const {} = struct {{
		{}
	}};
	]], { i(1), i(0) })),
})
