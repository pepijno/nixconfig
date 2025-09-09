(local nvim (require :lib/nvim))

(local hardmode-message "Neovim Hard-Mode |':lua easymode()' to exit|")
(var hardmode-enabled false)

(fn conditional-move [key]
  (fn []
    (let [count vim.v.count]
      (if (> count 1) (vim.cmd (.. "normal! " count key))
          (print hardmode-message)))))

(local noremap {:noremap true})
(local silent {:silent true})

(fn _G.hardmode []
  (set vim.o.backspace "")
  (nvim.keymap [:n :i :v] :<Left> (fn [] (print hardmode-message)) noremap)
  (nvim.keymap [:n :i :v] :<Rigth> (fn [] (print hardmode-message)) noremap)
  (nvim.keymap [:n :i :v] :<Up> (fn [] (print hardmode-message)) noremap)
  (nvim.keymap [:n :i :v] :<Down> (fn [] (print hardmode-message)) noremap)
  (nvim.keymap [:n :i :v] :<PageUp> (fn [] (print hardmode-message)) noremap)
  (nvim.keymap [:n :i :v] :<PageDown> (fn [] (print hardmode-message)) noremap)
  (nvim.keymap [:n :v] :h (fn [] (print hardmode-message)) noremap)
  (nvim.keymap [:n :v] :j (conditional-move :j) noremap)
  (nvim.keymap [:n :v] :k (conditional-move :k) noremap)
  (nvim.keymap [:n :v] :l (fn [] (print hardmode-message)) noremap)
  (nvim.keymap [:n :v] "-" (fn [] (print hardmode-message)) noremap)
  (nvim.keymap [:n :v] "+" (fn [] (print hardmode-message)) noremap)
  (set hardmode-enabled true)
  (print hardmode-message))

(fn _G.easymode []
  (set vim.o.backspace "indent,eol,start")
  (nvim.keymap [:n :i :v] :<Left> :<Left> silent)
  (nvim.keymap [:n :i :v] :<Rigth> :<Right> silent)
  (nvim.keymap [:n :i :v] :<Up> :<Up> silent)
  (nvim.keymap [:n :i :v] :<Down> :<Down> silent)
  (nvim.keymap [:n :i :v] :<PageUp> :<PageUp> silent)
  (nvim.keymap [:n :i :v] :<PageDown> :<PageDown> silent)
  (nvim.keymap [:n :v] :h :h silent)
  (nvim.keymap [:n :v] :j :j silent)
  (nvim.keymap [:n :v] :k :k silent)
  (nvim.keymap [:n :v] :l :l silent)
  (nvim.keymap [:n :v] "-" "-" silent)
  (nvim.keymap [:n :v] "+" "+" silent)
  (set hardmode-enabled true)
  (print "You are weak..."))

