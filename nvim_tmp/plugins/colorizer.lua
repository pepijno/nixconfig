return {
	{
		'norcalli/nvim-colorizer.lua',
		config = function ()
			require('colorizer').setup(
			{ "*" },
			{
				RGB = true,
				RRGGBB = true,
				names = false,
				RRGGBBAA = true,
				rgb_fn = false,
				hsl_fn = false,
				css = true,
				css_fn = false,
				mode = 'background',
			}
			)
		end,
	},
}
