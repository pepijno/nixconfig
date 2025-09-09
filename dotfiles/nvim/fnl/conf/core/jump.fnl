(local nvim (require :lib/nvim))

(vim.pack.add ["https://github.com/catppuccin/nvim"])

(local latte ((. (require :catppuccin.palettes) :get_palette) :latte))

(fn dec [x] (- x 1))
(fn inc [x] (+ x 1))

;; State management
(var state {:visible-text {} :has-locations false :keys {} :key-handler-id nil})

;; Utility functions
(fn get-visible-text []
  "Get all visible text lines in the current window"
  (let [win (vim.api.nvim_get_current_win)
        start-line (vim.fn.line :w0 win)
        end-line (vim.fn.line :w$ win)
        buf (vim.api.nvim_win_get_buf win)]
    (vim.api.nvim_buf_get_lines buf (dec start-line) end-line false)))

(fn window-to-buffer-row [win-row ?win]
  "Convert window row to buffer row coordinate"
  (let [win (or ?win (vim.api.nvim_get_current_win))
        top-line (vim.fn.line :w0 win)]
    (+ (dec top-line) win-row)))

(local grey-namespace (vim.api.nvim_create_namespace :buffer_grey_overlay))
(vim.api.nvim_set_hl 0 :JumpGreyOverlay {:bg :NONE :fg "#808080"})

;; Buffer styling functions
(fn make-buffer-grey []
  "Apply grey overlay to entire buffer"
  (let [buf (vim.api.nvim_get_current_buf)
        line-count (vim.api.nvim_buf_line_count buf)]
    (vim.api.nvim_buf_clear_namespace buf grey-namespace 0 -1)
    (for [line 0 (dec line-count)]
      (let [line-text (?. (vim.api.nvim_buf_get_lines buf line (inc line) false)
                          1)]
        (when (and line-text (> (length line-text) 0))
          (vim.api.nvim_buf_set_extmark buf grey-namespace line 0
                                        {:end_col (length line-text)
                                         :hl_group :JumpGreyOverlay
                                         :priority 1000}))))))

(fn restore-buffer-colors []
  "Remove grey overlay from buffer"
  (let [buf (vim.api.nvim_get_current_buf)]
    (vim.api.nvim_buf_clear_namespace buf grey-namespace 0 -1)))

(fn find-character [char]
  (var matches {})
  (each [id line (pairs state.visible-text)]
    (var b 1)
    (while true
      (local (x y) (string.find line char b true))
      (when (= x nil) (lua :break))
      (vim.list_extend matches [{: x :y id}])
      (set b (+ x 1))))
  matches)

(fn window-to-buffer-row [win-row win]
  (set-forcibly! win (or win (vim.api.nvim_get_current_win)))
  (local top-line (vim.fn.line :w0 win))
  (local buffer-row (+ (- top-line 1) win-row))
  buffer-row)

(fn overlay-character [char line col win]
  (set-forcibly! win (or win (vim.api.nvim_get_current_win)))
  (local buf (vim.api.nvim_win_get_buf win))
  (local extmark-id
         (vim.api.nvim_buf_set_extmark buf grey-namespace
                                       (window-to-buffer-row line win) col
                                       {:priority 1000
                                        :virt_text [[char :RedOverlay]]
                                        :virt_text_pos :overlay}))
  extmark-id)

(fn remove-overlay [extmark-id buf]
  (set-forcibly! buf (or buf (vim.api.nvim_get_current_buf)))
  (vim.api.nvim_buf_del_extmark buf grey-namespace extmark-id))

(fn clear-all-overlays [buf]
  (set-forcibly! buf (or buf (vim.api.nvim_get_current_buf)))
  (vim.api.nvim_buf_clear_namespace buf grey-namespace 0 (- 1)))

(local used-keys [:n :t :e :s :i :r :o :a])

(fn init-characters [char]
  (local chars (find-character char))
  (var i 0)
  (each [_ char (ipairs chars)]
    (local key (. used-keys (+ i 1)))
    (if (= (. state.keys key) nil)
        (tset state.keys key [char])
        (table.insert (. state.keys key) char))
    (set i (% (+ i 1) (length used-keys)))))

(fn print-characters []
  (clear-all-overlays)
  (vim.api.nvim_set_hl 0 :RedOverlay {:bold true :fg latte.red})
  (each [char locs (pairs state.keys)]
    (each [_ loc (ipairs locs)]
      (overlay-character char (- loc.y 1) (- loc.x 1)))))

(fn update-characters [char stop-fn]
  (when (not= (. state.keys char) nil)
    (local ks (. state.keys char))
    (if (= (length ks) 1)
        (do
          (vim.api.nvim_win_set_cursor 0
                                       [(window-to-buffer-row (. (. ks 1) :y))
                                        (- (. (. ks 1) :x) 1)])
          (stop-fn))
        (do
          (set state.keys {})
          (var i 0)
          (each [_ char (ipairs ks)]
            (local key (. used-keys (+ i 1)))
            (if (= (. state.keys key) nil)
                (tset state.keys key [char])
                (table.insert (. state.keys key) char))
            (set i (% (+ i 1) (length used-keys))))))))

(fn stop-key-capture []
  (when state.key-handler-id
    (vim.on_key nil state.key-handler-id)
    (set state.key-handler-id nil)))

(fn stop []
  (set state.has-locations false)
  (set state.keys {})
  (stop-key-capture)
  (restore-buffer-colors)
  (clear-all-overlays))

(fn handle-keypress [key typed]
  (if (or (= key "\027") (= typed :<Esc>))
      (do
        (stop)
        (lua :return))
      (not state.has-locations)
      (do
        (set state.has-locations true)
        (init-characters key)
        (print-characters))
      (do
        (update-characters key stop)
        (print-characters)))
  "")

; Returning empty string stops behaviour of pressed keys

(fn start-key-capture []
  (set state.key-handler-id (vim.on_key handle-keypress)))

(nvim.keymap [:n] :<leader>s (fn []
                               (set state.visible-text (get-visible-text))
                               (start-key-capture)
                               (make-buffer-grey))
             {:desc :Jump})
