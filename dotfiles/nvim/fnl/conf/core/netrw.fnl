(local nvim (require :lib/nvim))

;; Configuration
(local config {:netrw {:keepdir false
                       :banner false
                       :list-hide "\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"
                       :localcopydircmd "cp -r"}
               :namespace-name :netrw
               :node-types {:directory 0 :file 1 :symlink 2}})

;; Netrw settings
(fn setup-netrw-options []
  "Configure netrw global options"
  (nvim.g :netrw_keepdir config.netrw.keepdir)
  (nvim.g :netrw_banner config.netrw.banner)
  (nvim.g :netrw_list_hide config.netrw.list-hide)
  (nvim.g :netrw_localcopydircmd config.netrw.localcopydircmd))

;; Node parsing functions
(fn parse-symlink [line]
  "Parse symlink entry: 'target@ -> destination'"
  (let [(_ node) (string.find line "^(.+)@\t%s*%-%->%s*(.+)")]
    (when node
      {: node :type config.node-types.symlink})))

(fn parse-directory [line]
  "Parse directory entry: 'dirname/'"
  (let [(_ dir) (string.find line "^(.*)/")]
    (when dir
      {:node dir :type config.node-types.directory})))

(fn parse-file [line]
  "Parse regular file entry, handling executable marker"
  (let [cleaned-line (if (= (string.sub line -1) "*")
                         (string.sub line 1 -2)
                         line)]
    {:node cleaned-line :type config.node-types.file}))

(fn parse-node [line]
  "Parse a netrw line into a node object"
  ;; Skip comment lines and empty lines
  (when (or (string.find line "^\"") (= line ""))
    (lua "return nil"))
  ;; Try parsing as different node types
  (or (parse-symlink line) (parse-directory line) (parse-file line)))

;; Icon handling
(fn get-node-icon [node]
  "Get icon and highlight group for a node"
  (let [mini-icons (require :mini.icons)
        icon-type (if (= node.type config.node-types.directory) :directory
                      :file)]
    (mini-icons.get icon-type node.node)))

(fn create-extmark [bufnr namespace line-idx node]
  "Create an extmark with icon for a node"
  (let [(icon hl-group) (get-node-icon node)
        opts {:id (+ line-idx 1) :sign_text icon}]
    (when hl-group
      (tset opts :sign_hl_group hl-group))
    (vim.api.nvim_buf_set_extmark bufnr namespace line-idx 0 opts)))

;; Main embellishment function
(fn embellish-buffer [bufnr]
  "Add icons to netrw buffer using extmarks"
  (let [namespace (vim.api.nvim_create_namespace config.namespace-name)
        lines (vim.api.nvim_buf_get_lines bufnr 0 -1 false)]
    ;; Process each line and add icons
    (each [line-idx line (ipairs lines)]
      (let [node (parse-node line)]
        (when node
          (create-extmark bufnr namespace (- line-idx 1) node))))
    ;; Normalize cursor position  
    (vim.cmd "norm! lh")))

;; Event handling
(fn is-netrw-buffer? []
  "Check if current buffer is a netrw buffer"
  (and vim.bo (= vim.bo.filetype :netrw)))

(fn on-netrw-modified []
  "Handle netrw buffer modification"
  (when (is-netrw-buffer?)
    (vim.opt_local.signcolumn :yes)
    (let [bufnr (vim.api.nvim_get_current_buf)]
      (embellish-buffer bufnr))))

(fn setup-autocommands []
  "Set up autocommands for netrw enhancement"
  (let [group (vim.api.nvim_create_augroup config.namespace-name {:clear false})]
    (vim.api.nvim_create_autocmd :BufModifiedSet
                                 {:pattern "*"
                                  : group
                                  :desc "Add icons to netrw buffers"
                                  :callback on-netrw-modified})))

;; Public setup function
(fn setup []
  "Initialize netrw enhancements"
  (setup-netrw-options)
  (setup-autocommands))

;; Initialize
(setup)
