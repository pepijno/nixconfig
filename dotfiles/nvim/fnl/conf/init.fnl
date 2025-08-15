(local nvim (require :lib/nvim))

(require :conf.core.options)
(require :conf.core.keymaps)
(require :conf.core.autocmds)
(require :conf.core.lsp)
(require :conf.core.statusline)
(require :conf.core.indentscope)
(require :conf.core.switchcase)

(nvim.keymap [:n] :<leader>x ":source ~/.config/nvim/init.lua<Return>"
             {:desc "Source init.lua"})

(lambda github [name] (.. "https://github.com/" name))

(vim.pack.add [(github :folke/which-key.nvim)
               ; github("tpope/vim-sleuth"),
               (github :j-hui/fidget.nvim)
               (github :catppuccin/nvim)
               (github :lewis6991/gitsigns.nvim)
               {:src (github :saghen/blink.cmp)
                :version (vim.version.range :1.*)}
               (github :ibhagwan/fzf-lua)
               (github :echasnovski/mini.icons)
               (github :nvim-treesitter/nvim-treesitter)
               (github :nvim-treesitter/nvim-treesitter-textobjects)
               (github :nvim-treesitter/nvim-treesitter-context)
               (github :nvim-treesitter/playground)
               (github :stevearc/conform.nvim)
               (github :neovim/nvim-lspconfig)
               (github :windwp/nvim-autopairs)
               (github :stevearc/oil.nvim)])

(local langs-ensure-installed [:asm
                               :lua
                               :nix
                               :zig
                               :haskell
                               :c
                               :bash
                               :angular
                               :typescript
                               :javascript
                               :html
                               :css
                               :json
                               :fish
                               :java
                               :kotlin
                               :xml
                               :toml
                               :sql
                               :fennel
                               :cpp])

(local formatters-by-ft {:asm [:asmfmt]
                         :lua [:stylua]
                         :nix [:nixfmt]
                         :zig [:zigfmt]
                         :haskell [:ormolu]
                         :c [:clang_format]
                         :bash [:beautysh]
                         :sh [:beautysh]
                         :angular [:prettier]
                         :typescript [:prettier]
                         :json [:jq]
                         :fish [:fish_indent]
                         :toml [:tombi]
                         :xml [:xmllint]
                         :fennel [:fnlfmt]})

(local formatters {:prettier {:printWidth 100
                              :useTabs false
                              :semi true
                              :singleQuote true
                              :trailingComma :all
                              :arrowParens :always
                              :htmlWhitespaceSensitivity :strict
                              :bracketSpacing true}})

(vim.lsp.config :lua_ls
                {:settings {:Lua {:workspace {:library (vim.api.nvim_get_runtime_file ""
                                                                                      true)}}}})

(vim.lsp.config :clangd
                {:capabilities {:textDocument {:completion {:completionItem {:snippetSupport false }}}}})

(vim.lsp.enable [:lua_ls
                 :asm_lsp
                 :nixd
                 :zls
                 :hls
                 :clangd
                 :bashls
                 :cssls
                 :html
                 :ts_ls
                 :jsonls
                 :fish_lsp
                 :angularls
                 :tombi
                 :lemminx
                 :jdtls
                 :fennel_ls])

; catppuccin
;------------------------------------------------------------------------------------------------------------------------
((. (require :catppuccin) :setup) {:flavour :latte
                                   :transparent_background true})

(vim.cmd.colorscheme :catppuccin-latte)

; Which Key
;------------------------------------------------------------------------------------------------------------------------
(local wk (require :which-key))
((. wk :setup) {:win {:border :single} :icon {:colors true}})
((. wk :add) [{1 :<leader>f :group "[F]ind"}
              {1 :<leader>l :group "[L]SP"}
              {1 :<leader>lg :group "[G]oto"}
              {1 :<leader>t :group "[T]reesitter"}])

(nvim.keymap [:n] :<leader>? (fn [] ((. wk :show) {:global false}))
             {:desc "Buffer Local Keymaps (which-key)"})

; fidget
;------------------------------------------------------------------------------------------------------------------------
((. (require :fidget) :setup) {:notification {:window {:winblend 100}}})

; oil.nvim
;------------------------------------------------------------------------------------------------------------------------
((. (require :oil) :setup))
(nvim.keymap [:n] "-" :<cmd>Oil<Return> {:desc "Open Oil"})

; gitsigns.nvim
;------------------------------------------------------------------------------------------------------------------------
((. (require :gitsigns) :setup) {:signs {:add {:text "│"}
                                         :change {:text "│"}
                                         :delete {:text "_"}
                                         :topdelete {:text "‾"}
                                         :changedelete {:text "~"}
                                         :untracked {:text "┆"}}
                                 :attach_to_untracked true})

; blink.cmp
;------------------------------------------------------------------------------------------------------------------------
(local cmp (require :blink.cmp))
((. cmp :setup) {:keymap {:preset :none
                          :<C-n> [:select_next :fallback_to_mappings]
                          :<C-p> [:select_prev :fallback_to_mappings]
                          :<C-y> [:select_and_accept :fallback_to_mappings]}
                 :appearance {:nerd_font_variant :mono}
                 :completion {:menu {:border :single
                                     :draw {:columns [{1 :label
                                                       2 :label_description
                                                       :gap 1}
                                                      {1 :kind_icon :gap 1}
                                                      {1 :kind :gap 1}
                                                      {1 :source_name}]}}
                              :documentation {:auto_show true
                                              :window {:border :single}}
                              :list {:selection {:preselect false
                                                 :auto_insert false}}}
                 :sources {:default [:lsp :path :buffer]
                           :providers {:lsp {:fallbacks [:buffer]}}}
                 :fuzzy {:implementation :lua}
                 :signature {:enabled true}})

; fzf-lua
;------------------------------------------------------------------------------------------------------------------------
(lambda fzf-lua [builtin ?opts]
  (lambda []
    ((. (require :fzf-lua) builtin) ?opts)))

((. (require :fzf-lua) :setup) {:winopts {:border :single
                                          :preview {:border :single
                                                    :horizontal "right:50%"}
                                          :fullscreen false}
                                :fzf_colors true
                                :keymap {:builtin {:<C-d> :preview-page-down
                                                   :<C-u> :preview-page-up}}
                                :files {:file_icons :mini}
                                :grep {:file_icons :mini}})

(nvim.keymap [:n] :<leader>ff (fzf-lua :files) {:desc "[F]iles"})
(nvim.keymap [:n] :<leader>fr (fzf-lua :live_grep_native) {:desc "[R]ipgrep"})
(nvim.keymap [:v] :<leader>fR (fzf-lua :grep_visual) {:desc "[R]ipgrep visual"})
(nvim.keymap [:n] :<leader>fR (fzf-lua :grep_cword) {:desc "[R]ipgrep word"})
(nvim.keymap [:n] :<leader>fk (fzf-lua :keymaps) {:desc "[K]eymaps"})
(nvim.keymap [:n] :<leader>fc (fzf-lua :resume) {:desc "[C]ontinue"})

; treesitter
;------------------------------------------------------------------------------------------------------------------------
(local current-installed
       ((. (require :nvim-treesitter.info) :installed_parsers)))

(local mandatory-installed [:c
                            :lua
                            :markdown
                            :markdown_inline
                            :query
                            :vim
                            :vimdoc])

(each [_ parser (ipairs mandatory-installed)]
  (when (not (vim.list_contains langs-ensure-installed parser))
    (vim.list_extend langs-ensure-installed [parser])))

(var has-new-ts-parsers false)
(each [_ parser (ipairs langs-ensure-installed)]
  (when (not (vim.list_contains current-installed parser))
    (set has-new-ts-parsers true)
    (lua :break)))

(local old-parsers {})
(each [_ parser (ipairs current-installed)]
  (when (not (vim.list_contains langs-ensure-installed parser))
    (tset old-parsers (+ (length old-parsers) 1) parser)))

((. (require :nvim-treesitter.configs) :setup) {:ensure_installed langs-ensure-installed
                                                :highlight {:enable true
                                                            :use_languagetree true}
                                                :autopairs {:enable false}
                                                :incremental_selection {:enable true
                                                                        :keymaps {:init_selection :<Return>
                                                                                  :node_incremental :<Return>
                                                                                  :node_decremental :<Backspace>}}
                                                :indent {:enable true}
                                                :textobjects {:select {:enable true
                                                                       :lookahead true
                                                                       :keymaps {:af "@function.outer"
                                                                                 :if "@function.inner"
                                                                                 :ac "@class.outer"
                                                                                 :ic "@class.inner"}}
                                                              :swap {:enable true
                                                                     :swap_next {:<leader>ta "@parameter.inner"}
                                                                     :swap_previous {:<leader>tA "@parameter.inner"}}}})

(when has-new-ts-parsers (vim.cmd :TSUpdate))

(each [_ parser (ipairs old-parsers)] (vim.cmd (.. "TSUninstall " parser)))

; conform
;------------------------------------------------------------------------------------------------------------------------
((. (require :conform) :setup) {:formatters_by_ft formatters-by-ft
                                : formatters})

; nvim-autopairs
;------------------------------------------------------------------------------------------------------------------------
((. (require :nvim-autopairs) :setup) {})
