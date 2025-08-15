(local nvim (require :lib/nvim))

(vim.pack.add ["https://github.com/catppuccin/nvim"])

(local latte ((. (require :catppuccin.palettes) :get_palette) :latte))

;; Configuration constants
(local config {:max-lines 10000
               :symbol "╎"
               :hl-group-on :IndentscopeSymbol
               :hl-group-off :IndentscopeSymbolOff})

(var current-scope {})

(local ns-id (vim.api.nvim_create_namespace :Indentscope))

(fn get-line-indent [line]
  "Get effective indentation for a line, considering blank lines"
  (let [prev-nonblank (vim.fn.prevnonblank line)
        base-indent (vim.fn.indent prev-nonblank)]
    (if (not= line prev-nonblank)
        (let [next-indent (vim.fn.indent (vim.fn.nextnonblank line))]
          (math.max base-indent next-indent))
        base-indent)))

(fn cast-ray [start-line target-indent direction]
  "Cast a ray up/down to find scope boundaries"
  (let [is-down? (= direction :down)
        final-line (if is-down? (vim.fn.line "$") 1)
        increment (if is-down? 1 -1)
        line-diff (math.abs (- start-line final-line))
        ; Limit search range for performance
        actual-final (if (> line-diff config.max-lines)
                         (+ start-line (* increment config.max-lines))
                         final-line)
        is-incomplete (> line-diff config.max-lines)]
    (var min-indent math.huge) ; Search for scope boundary
    (for [line start-line actual-final increment]
      (let [new-indent (get-line-indent (+ line increment))]
        (when (< new-indent target-indent)
          (lua "return line, min_indent, nil"))
        (when (< new-indent min-indent)
          (set min-indent new-indent))))
    (values actual-final min-indent is-incomplete)))

(fn get-scope []
  "Calculate the current indentation scope"
  (let [curpos (vim.fn.getcurpos)
        line (. curpos 2)
        col (or (. curpos 5) math.huge)
        line-indent (get-line-indent line)
        indent (math.min col line-indent)
        body {:indent line-indent}]
    (if (<= indent 0)
        ;; At top level - whole buffer is scope
        (do
          (set body.top 1)
          (set body.bottom (vim.fn.line "$"))
          (set body.indent line-indent))
        ;; Find actual scope boundaries
        (let [(up-line up-min-indent up-incomplete?) (cast-ray line indent :up)
              (down-line down-min-indent down-incomplete?) (cast-ray line
                                                                     indent
                                                                     :down)]
          (set body.top up-line)
          (set body.bottom down-line)
          (set body.indent (math.min line-indent up-min-indent down-min-indent))
          (set body.is-incomplete (or up-incomplete? down-incomplete?))))
    {: body
     :border-indent (math.max (get-line-indent (- body.top 1))
                              (get-line-indent (+ body.bottom 1)))
     :buf-id (vim.api.nvim_get_current_buf)}))

(lambda compute-indicator [?scope]
  (let [scope (or ?scope current-scope)
        indent (or scope.border-indent (- scope.body.intent 1))]
    (when (< indent 0) {})
    (let [col (- indent (. (vim.fn.winsaveview) :leftcol))]
      (when (< col 0) {})
      (let [is-aligned? (= (% indent (vim.fn.shiftwidth)) 0)
            hl-group (if is-aligned? config.hl-group-on config.hl-group-off)
            virt-text [[config.symbol hl-group]]]
        {:bottom scope.body.bottom
         :buf-id (vim.api.nvim_get_current_buf)
         :top scope.body.top
         : virt-text
         :virt-text-win-col col}))))

(fn draw-scope [?scope]
  "Draw the scope indicator using extmarks"
  (let [scope (or ?scope {})
        indicator (compute-indicator scope)]
    (when (and indicator.top indicator.bottom)
      (let [extmark-opts {:hl_mode :combine
                          :right_gravity false
                          :virt_text indicator.virt-text
                          :virt_text_win_col indicator.virt-text-win-col
                          :virt_text_pos :overlay}]
        ;; Handle breakindent setting
        (when (and vim.wo.breakindent (= vim.wo.showbreak ""))
          (tset extmark-opts :virt_text_repeat_linebreak true))
        ;; Draw extmarks for each line in scope
        (for [line indicator.top indicator.bottom]
          (vim.api.nvim_buf_set_extmark indicator.buf-id ns-id (- line 1) 0
                                        extmark-opts))))))

(fn clear-scope []
  "Clear the current scope visualization"
  (pcall vim.api.nvim_buf_clear_namespace (or current-scope.buf-id 0) ns-id 0
         -1)
  (set current-scope {}))

(fn draw []
  "Main drawing function - compute and draw current scope"
  (let [scope (get-scope)]
    (clear-scope)
    (set current-scope scope)
    (draw-scope scope)))

(fn create-default-hl []
  "Create default highlight groups"
  (vim.api.nvim_set_hl 0 :IndentscopeSymbol {:bold true :fg latte.green})
  (vim.api.nvim_set_hl 0 :IndentscopeSymbolOff {:link :IndentscopeSymbol}))

(fn setup-autocmds []
  "Set up autocommands for automatic drawing"
  (let [gr (vim.api.nvim_create_augroup :Indentscope {})
        au (fn [event pattern callback desc]
             (vim.api.nvim_create_autocmd event
                                          {:group gr
                                           : pattern
                                           : callback
                                           : desc}))
        draw-events [:CursorMoved
                     :CursorMovedI
                     :ModeChanged
                     :TextChanged
                     :TextChangedI
                     :TextChangedP
                     :WinScrolled]]
    (au draw-events "*" (fn [] (draw)) "Auto draw indentscope")
    (au :ColorScheme "*" create-default-hl "Ensure colors")))

(setup-autocmds)
(create-default-hl)
