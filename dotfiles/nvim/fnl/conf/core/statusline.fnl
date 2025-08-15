(local nvim (require :lib/nvim))

(vim.pack.add ["https://github.com/catppuccin/nvim"])

(local latte ((. (require :catppuccin.palettes) :get_palette) :latte))

;; Configuration
(local config {:no-name-text "[No Name]"
               :modified-symbol "[+]"
               :readonly-symbol "[-]"})

;; Color scheme definitions
(local theme-colors {:normal {:primary latte.blue}
                     :insert {:primary latte.green}
                     :replace {:primary latte.red}
                     :visual {:primary latte.mauve}
                     :command {:primary latte.yellow}})

(fn create-section-colors []
  "Generate section colors for all modes"
  (let [sections {}]
    (each [mode colors (pairs theme-colors)]
      (tset sections mode
            {:a {:bg colors.primary :fg latte.base :gui :bold}
             :b {:bg latte.surface0 :fg colors.primary}
             :c {:bg latte.base :fg colors.primary}}))
    ;; Add derived modes
    (tset sections :terminal sections.command)
    (tset sections :inactive sections.normal)
    (tset sections :background {:a {:bg latte.base :fg latte.surface0}})
    sections))

(local section-colors (create-section-colors))

;; Mode mappings
(local vim-modes {;; Normal modes
                  :n :NORMAL
                  :nt :NORMAL
                  :ntT :NORMAL
                  :niI :NORMAL
                  :niR :NORMAL
                  :niV :NORMAL
                  ;; Insert modes  
                  :i :INSERT
                  :ic :INSERT
                  :ix :INSERT
                  ;; Visual modes
                  :v :VISUAL
                  :vs :VISUAL
                  :V :V-LINE
                  :Vs :V-LINE
                  "\022" :V-BLOCK
                  "\022s" :V-BLOCK
                  ;; Select modes
                  :s :SELECT
                  :S :S-LINE
                  "\019" :S-BLOCK
                  ;; Replace modes
                  :R :REPLACE
                  :Rc :REPLACE
                  :Rx :REPLACE
                  :r :REPLACE
                  :Rv :V-REPLACE
                  :Rvc :V-REPLACE
                  :Rvx :V-REPLACE
                  ;; Command modes
                  :c :COMMAND
                  :ce :EX
                  :cv :EX
                  ;; Other modes
                  :! :SHELL
                  :t :TERMINAL
                  :no :O-PENDING
                  "no\022" :O-PENDING
                  :noV :O-PENDING
                  :nov :O-PENDING
                  :r? :CONFIRM
                  :rm :MORE})

(local mode-color-map {:NORMAL :normal
                       :INSERT :insert
                       :VISUAL :visual
                       :V-LINE :visual
                       :V-BLOCK :visual
                       :SELECT :visual
                       :S-LINE :visual
                       :S-BLOCK :visual
                       :REPLACE :replace
                       :V-REPLACE :replace
                       :COMMAND :command
                       :EX :command
                       :SHELL :command
                       :TERMINAL :command
                       :O-PENDING :normal
                       :CONFIRM :command
                       :MORE :command})

(fn highlight [name foreground background ?gui]
  "Create a highlight group"
  (let [gui (or ?gui :nocombine)
        command (string.format "highlight! %s guifg=%s guibg=%s gui=%s" name
                               foreground background gui)]
    (vim.cmd command)))

(fn create-highlight-groups []
  "Create all statusline highlight groups"
  (each [mode sections (pairs section_colors)]
    (each [section color (pairs sections)]
      (let [hlgroup (string.format "statusline_%s_%s" mode section)]
        (highlight hlgroup color.fg color.bg color.gui)))))

(fn highlight-group [mode section]
  "Generate highlight group reference for statusline"
  (string.format "%%#statusline_%s_%s#" mode section))

(fn get-mode []
  "Get current vim mode name"
  (let [mode-code (. (vim.api.nvim_get_mode) :mode)]
    (or (. vim-modes mode-code) mode-code)))

(fn get-file-name []
  (let [filename (vim.fn.expand "%:t")
        name (if (= filename "") config.no-name-text filename)
        escaped-name (name:gsub "%%" "%%%%")
        symbols []]
    ;; Add modification indicators
    (when vim.bo.modified
      (table.insert symbols config.modified-symbol))
    (when (or (not vim.bo.modifiable) vim.bo.readonly)
      (table.insert symbols config.readonly-symbol))
    ;; Combine name with symbols
    (if (> (length symbols) 0)
        (.. escaped-name " " (table.concat symbols ""))
        escaped-name)))

(fn get-filetype []
  "Get current filetype, escaped for statusline"
  (let [ft (or vim.bo.filetype "")]
    (ft:gsub "%%" "%%%%")))

(fn get-progress []
  "Get current position as percentage"
  (let [cur (vim.fn.line ".")
        total (vim.fn.line "$")]
    (if (= cur 1) :Top
        (= cur total) :Bot
        (string.format "%2d%%%%" (math.floor (* (/ cur total) 100))))))

(fn get-location []
  (let [line (vim.fn.line ".")
        col (vim.fn.charcol ".")]
    (string.format "%3d:%-2d" line col)))

(fn with-spaces [text]
  (.. " " text " "))

(fn build-statusline []
  (let [mode (get-mode)
        filename (get-file-name)
        filetype (get-filetype)
        progress (get-progress)
        location (get-location)
        mode-color (. mode-color-map mode)
        ft-section (if (= filetype "") ""
                       (string.format " %s |" filetype))
        parts [(highlight-group mode-color :c)
               ""
               (highlight-group mode-color :a)
               (with-spaces mode)
               (highlight-group mode-color :b)
               (with-spaces filename)
               (highlight-group :background :a)
               ""
               "%*%="
               (highlight-group :background :a)
               ""
               (highlight-group mode-color :b)
               filetype
               (with-spaces progress)
               (highlight-group mode-color :a)
               (with-spaces location)
               (highlight-group mode-color :c)
               ""]]
    (table.concat parts "")))

;; Setup and initialization
(fn create-autocommands []
  "Set up autocommands for statusline updates"
  (let [group (vim.api.nvim_create_augroup :CustomStatusline {})]
    (vim.api.nvim_create_autocmd [:ModeChanged :WinEnter :BufEnter]
                                 {: group
                                  :desc "Update statusline"
                                  :callback (fn []
                                              (vim.wo.statusline "%{%luaeval('require(\"conf.core.statusline\").update_statusline()')%}"))})))

(fn setup []
  (create-highlight-groups)
  (nvim.opt :showmode false)
  (nvim.opt :statusline
            "%{%luaeval('require(\"conf.core.statusline\").update_statusline()')%}"))

;; Initialize
(setup)

{:update_statusline build-statusline}
