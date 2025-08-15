(local nvim (require :lib/nvim))

; Number of spaces shown per <tab>
(nvim.opt :tabstop 4)
; Number of spaces applied when pressing <tab>
(nvim.opt :softtabstop 4)
; Amount to indent with << and >>
(nvim.opt :shiftwidth 4)
; Convert tabs to spaces
(nvim.opt :expandtab true)

; <Backspace> will delete a 'shiftwidth' worth of space at the start of the line
(nvim.opt :smarttab true)
; Smart auto indenting on new line
(nvim.opt :smartindent true)
; Copy indent from current line on new line
(nvim.opt :autoindent true)

; Show line numbers
(nvim.opt :number true)
; Show relative line numbers
(nvim.opt :relativenumber true)

; Highlight the text line of the cursor
(nvim.opt :cursorline true)

; Store undo between sessions
(nvim.opt :undofile true)
; Disable use of swap files
(nvim.opt :swapfile false)
; Disabled the use of backup files
(nvim.opt :backup false)

; Disable showing modes in status line as we have custom status line
(nvim.opt :showmode false)

; Highlight all the matches of search pattern
(nvim.opt :hlsearch true)
; Set incremental search
(nvim.opt :incsearch true)
; Case insensitive searching
(nvim.opt :ignorecase true)
; Case sensitivie searching when upper case characters are in search
(nvim.opt :smartcase true)

; Always show the sign column
(nvim.opt :signcolumn :yes)

; Length of time to wait before triggering the plugin
(nvim.opt :updatetime 300)

; Splitting a new window below the current one
(nvim.opt :splitbelow true)
; Splitting a new window at the right of the current one
(nvim.opt :splitright true)

; Number of lines to keep above and below the cursor
(nvim.opt :scrolloff 999)

; Number of columns to keep at the sides of the cursor
(nvim.opt :sidescrolloff 8)

; Disable mouse support
(nvim.opt :mouse :n)

; Do not abandon unloaded buffers
(nvim.opt :hidden true)

; Disable line wrapping
(nvim.opt :wrap false)

; Maximum number of items in popup window
(nvim.opt :pumheight 10)

; Length of time to wait for a mapped sequence
(nvim.opt :timeoutlen 300)

; Enable showing special characters
(nvim.opt :list true)
; Show line breaks
(nvim.opt :showbreak "↪\\")
; Set display of whitespace characters
(nvim.opt :listchars {:nbsp "␣" :space "⋅" :tab "> " :trail "-"})

; Use c file type for .h files
(nvim.g :c_syntax_for_h true)

; Set the border of all windows
(nvim.opt :winborder :single)

; ; Enable system clipboard access
; (nvim.opt :clipboard "unnamedplus")

; Have global status line, even for splits
(nvim.opt :laststatus 3)

; Set two lines for cmd
(nvim.opt :cmdheight 2)

; Disable native vim plugins
(nvim.g :loaded_2html_plugin false)
(nvim.g :loaded_getscript false)
(nvim.g :loaded_getscriptPlugin false)
(nvim.g :loaded_gzip false)
(nvim.g :loaded_logipat false)
(nvim.g :loaded_remote_plugins false)
(nvim.g :loaded_tar false)
(nvim.g :loaded_tarPlugin false)
(nvim.g :loaded_zip false)
(nvim.g :loaded_zipPlugin false)
(nvim.g :loaded_vimball false)
(nvim.g :loaded_vimballPlugin false)
(nvim.g :zipPlugin false)
