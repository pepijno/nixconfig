(local nvim (require :lib/nvim))

(let [group (nvim.augroup :highlight_yank {:clear true})]
  (nvim.autocmd [:TextYankPost]
                {: group
                 :callback (fn [] (vim.highlight.on_yank {:timeout 3000}))}))

(let [group (nvim.augroup :resize_splits {:clear true})]
  (nvim.autocmd [:VimResized] {: group :command "tabdo wincmd ="}))

(let [group (nvim.augroup :cursor_off {:clear true})]
  (nvim.autocmd [:WinLeave]
                {: group :callback (fn [] (nvim.opt :cursorline false))}))

(let [group (nvim.augroup :cursor_on {:clear true})]
  (nvim.autocmd [:WinEnter]
                {: group :callback (fn [] (nvim.opt :cursorline true))}))

(let [group (nvim.augroup :LuaHighlight {:clear true})]
  (nvim.autocmd [:BufWinEnter :BufRead :BufNewFile]
                {: group
                 :command "setlocal formatoptions-=c formatoptions-=r formatoptions-=o"}))
