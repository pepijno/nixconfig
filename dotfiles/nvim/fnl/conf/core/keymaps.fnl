(local nvim (require :lib/nvim))

(nvim.keymap [] :<Space> :<Nop>)
(nvim.g :mapleader (vim.keycode :<Space>))
(nvim.g :maplocalleader (vim.keycode :<Space>))

; undo breakpoints
(let [breakpoint-keys ["," "." "`" ";" "!" "?" "{" "}" "(" ")" "[" "]"]]
  (each [_ key (pairs breakpoint-keys)]
    (nvim.keymap [:i] key (.. key :<C-g>u) {:noremap true})))

; stay in indent mode
(nvim.keymap [:v] "<" :<gv {:noremap true})
(nvim.keymap [:v] ">" :>gv {:noremap true})
(nvim.keymap [:n] "<" "<<_" {:noremap true})
(nvim.keymap [:n] ">" ">>_" {:noremap true})

(nvim.keymap [:n] :n :nzzzv {:noremap true})
(nvim.keymap [:n] :N :Nzzzv {:noremap true})

(let [move-keys [:<C-u> :<C-d> :<C-y> :<C-e>]]
  (each [_ key (pairs move-keys)]
    (nvim.keymap [:n] key (.. key :zz) {:noremap true})))
