local M = {}
local home = os.getenv('HOME')

M.config = function()
end

M.setup = function()
	vim.g.dashboard_footer_icon = '🐬 '
	vim.g.dashboard_default_executive = 'telescope'
	vim.g.dashboard_custom_header = {
		"_|      _|  _|_|_|_|    _|_|    _|      _|  _|_|_|  _|      _|",
"_|_|    _|  _|        _|    _|  _|      _|    _|    _|_|  _|_|",
"_|  _|  _|  _|_|_|    _|    _|  _|      _|    _|    _|  _|  _|",
"_|    _|_|  _|        _|    _|    _|  _|      _|    _|      _|",
"_|      _|  _|_|_|_|    _|_|        _|      _|_|_|  _|      _|",
	}
	vim.g.dashboard_custom_section = {
		last_session = {
			description = {'  Recently laset session                  SPC s l'},
			command =  'SessionLoad'
		},
		find_file  = {
			description = {'  Find  File                              SPC f f'},
			command = 'Telescope find_files find_command=rg,--hidden,--files'
		},
		find_word = {
			description = {'  Find  word                              SPC f r'},
			command = 'DashboardFindWord'
		},
	}
end

return M
