local ls = require("luasnip")
local s, i, t, f = ls.s, ls.insert_node, ls.text_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("all", {
})

ls.add_snippets("lua", {
	s("req", fmt('local {} = require("{}")', { i(1), rep(1) })),
})
