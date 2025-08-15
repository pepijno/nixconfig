(local nvim (require :lib/nvim))

;; Configuration
(local config {:fzf {:code-actions {:winopts {:fullscreen false
                                              :preview {:hidden true}}}}
               :diagnostic {:severity-sort true
                            :float {:border :rounded :source :if_many}
                            :virtual-text {:source :if_many :spacing 2}
                            :signs {:error "󰅚 "
                                    :warn "󰀪 "
                                    :info "󰋽 "
                                    :hint "󰌶 "}}})

(fn create-fzf-handler [builtin ?opts]
  "Create a function that calls fzf-lua with the given builtin"
  (fn []
    ((. (require :fzf-lua) builtin) (or ?opts {}))))

(fn create-diagnostic-jump [direction ?severity]
  "Create a diagnostic jump function"
  (let [count (if (= direction :next) 1 -1)
        opts {: count :float true}]
    (when ?severity
      (tset opts :severity ?severity))
    (fn [] (vim.diagnostic.jump opts))))

(fn setup-document-highlight [client bufnr]
  "Set up document highlighting for capable clients"
  (when (client:supports_method vim.lsp.protocol.Methods.textDocument_documentHighlight
                                bufnr)
    (let [highlight-group (nvim.augroup :lsp-highlight {:clear false})
          detach-group (nvim.augroup :lsp-detach {:clear true})]
      ;; Set up highlighting on cursor hold
      (nvim.autocmd [:CursorHold :CursorHoldI]
                    {:buffer bufnr
                     :group highlight-group
                     :callback vim.lsp.buf.document_highlight})
      ;; Clear highlighting on cursor move
      (nvim.autocmd [:CursorMoved :CursorMovedI]
                    {:buffer bufnr
                     :group highlight-group
                     :callback vim.lsp.buf.clear_references})
      ;; Clean up on LSP detach
      (nvim.autocmd [:LspDetach]
                    {:group detach-group
                     :callback (fn [event]
                                 (vim.lsp.buf.clear_references)
                                 (nvim.clear-autocmds {:group :lsp-highlight
                                                       :buffer event.buf}))}))))

(nvim.autocmd [:LspAttach]
              {:callback (fn [event]
                           (local lsp vim.lsp)
                           (local opts {:silent true})

                           (fn opt [desc ?others]
                             (vim.tbl_extend :force opts {: desc}
                                             (or ?others {})))

                           (nvim.keymap [:n] :<leader>lgd
                                        (create-fzf-handler :lsp_definitions)
                                        (opt "[D]efinition"))
                           (nvim.keymap [:n] :<leader>lgi
                                        (create-fzf-handler :lsp_implementations)
                                        (opt "[I]mplementations"))
                           (nvim.keymap [:n] :<leader>lgr
                                        (create-fzf-handler :lsp_references)
                                        (opt "[R]eferences"))
                           (nvim.keymap [:v :n] :<leader>la
                                        (create-fzf-handler :lsp_code_actions
                                                            {:winopts {:fullscreen false
                                                                       :preview {:hidden true}}})
                                        (opt "Code [A]ctions"))
                           (nvim.keymap [:n] :<leader>lh
                                        (fn [] (lsp.buf.hover)) (opt "[H]over"))
                           (nvim.keymap [:n] :<leader>lf
                                        (fn []
                                          ((. (require :conform) :format) {:lsp_fallback true}))
                                        (opt "[F]ormat"))
                           (nvim.keymap [:n] :<leader>lH
                                        (fn []
                                          (lsp.buf.signature_help))
                                        (opt "Signature [H]elp"))
                           (nvim.keymap [:n] :<C-h>
                                        (fn []
                                          (lsp.buf.signature_help))
                                        (opt "Signature [H]elp"))
                           (nvim.keymap [:n] :<leader>ldj
                                        (create-diagnostic-jump :next)
                                        (opt "Next Diagnostic"))
                           (nvim.keymap [:n] :<leader>ldh
                                        (create-diagnostic-jump :prev)
                                        (opt "Prev Diagnostic"))
                           (nvim.keymap [:n] :<leader>lej
                                        (create-diagnostic-jump :next
                                                                vim.diagnostic.severity.ERROR)
                                        (opt "Next Error"))
                           (nvim.keymap [:n] :<leader>leh
                                        (create-diagnostic-jump :prev
                                                                vim.diagnostic.severity.ERROR)
                                        (opt "Prev Error"))
                           (nvim.keymap [:n] :<leader>lwj
                                        (create-diagnostic-jump :next
                                                                vim.diagnostic.severity.WARN)
                                        (opt "Next Warning"))
                           (nvim.keymap [:n] :<leader>lwh
                                        (create-diagnostic-jump :prev
                                                                vim.diagnostic.severity.WARN)
                                        (opt "Prev Warning"))
                           (nvim.keymap [:n] :<leader>lr
                                        (fn [] (lsp.buf.rename))
                                        (opt "[R]ename"))
                           (let [client (lsp.get_client_by_id event.data.client_id)]
                             (setup-document-highlight client event.buf)))})

(fn setup-diagnostic-config []
  "Configure vim diagnostics"
  (let [signs {}]
    ;; Build diagnostic signs
    (tset signs vim.diagnostic.severity.ERROR config.diagnostic.signs.error)
    (tset signs vim.diagnostic.severity.WARN config.diagnostic.signs.warn)
    (tset signs vim.diagnostic.severity.INFO config.diagnostic.signs.info)
    (tset signs vim.diagnostic.severity.HINT config.diagnostic.signs.hint)
    (vim.diagnostic.config {:severity_sort config.diagnostic.severity-sort
                            :float config.diagnostic.float
                            :signs {:text signs}
                            :virtual_text (vim.tbl_extend :force
                                                          config.diagnostic.virtual-text
                                                          {:format (fn [diagnostic]
                                                                     diagnostic.message)})})))

(setup-diagnostic-config)
