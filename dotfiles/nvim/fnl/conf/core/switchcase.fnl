(local nvim (require :lib/nvim))

(fn switch-case []
  (let [(line col) (unpack (vim.api.nvim_win_get_cursor 0))
        word (vim.fn.expand :<cword>)
        word-start (. (vim.fn.matchstrpos (vim.fn.getline ".")
                                          (.. "\\k*\\%" (+ col 1) "c\\k%"))
                      2)]
    (if (word:find "[a-z][A-z]")
        (let [snake-case-word (: (word:gsub "([a-z])([A-Z])" "%1_%2") :lower)]
          (vim.api.nvim_buf_set_text 0 (- line 1) word-start (- line 1)
                                     (+ word-start (length word))
                                     [snake-case-word]))
        (word:find "_[a-z]")
        (let [camel-case-word (word:gsub "(_)([a-z])" (fn [_ l] (: l :upper)))]
          (vim.api.nvim_buf_set_text 0 (- line 1) word-start (- line 1)
                                     (+ word-start (length word))
                                     [camel-case-word]))
        (vim.print "Not a snake_case or camelCase word"))))

(nvim.keymap [:n] :<leader>cc switch-case {:desc "Switch case"})
