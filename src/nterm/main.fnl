(module nterm.main
  {require {a aniseed.core
            s aniseed.string
            ui nterm.ui
            server-utils nterm.server
            nvim aniseed.nvim}})

;; Plugin to interact with the neovim terminal

;; Every terminal gets assigned and unique human readable ID, we call it
;; term-name. In all the commands, if no ID is specified, the term-name used is
;; "default"

;; User can define some options:
;; - direction: how to open a terminal, horizontal or vertical
;; - size: Default size when a terminal is opened, in number of lines
;; - shell: Default shell when a new terminal is created
;; - bg_color: background color for the terminal (TODO)

;; You can check if the VIM env variable exists to do different customization
;; in your shell for neoterm. (e.g.: display a different prompt inside neovim)

;; Exposed variables (can be read by plugins/custom scripts):
;; - b:nterm_name (notice that the term-name is also appended to the buffer
;; name. Buffer name is shown with `:ls!` or with the api vim.api.nvim_buf_get_name(0)
;; - g:current_term: current active terminal. Commands are send here, unless a
;; term-name is explicitly passed (TODO)


(def filetype :nterm)

(defonce terms {})

(def options
  {:maps true
   :size 20
   :direction :horizontal
   :shell "fish"
   :popup 2000
   :popup_pos :NE
   :autoclose 2000})

(def- loaded? false)

(defn get-terms []
  terms)

(defn- get-term-by-buf [buf-id]
  "Returns the associated terminal name with the given buffer"
  (let [term-info (->> (get-terms)
                   a.vals
                   (a.some #(when
                              (= buf-id (a.get $ :buf))
                              $)))]
    (a.get term-info :name)))

(defn- tab-get-open-terms []
  "Returns a list with the open terminals in the current tab"
  (->> (nvim.tabpage_list_wins 0)
    (a.map #(nvim.win_get_buf $))
    (a.filter #(= filetype (nvim.buf_get_option $ :filetype)))
    (a.map get-term-by-buf)))


(defn- get-term-win [name]
  "Retuns the window id for the term in the current tab, or nil if the term is
   closed"
  (let [name (or name :default)
        buf-id (a.get-in terms [name :buf])
        wins (nvim.tabpage_list_wins 0)]
    (a.some
      #(let [buf (nvim.win_get_buf $1)]
        (when (= buf buf-id)
          $1))
      wins)))

(defn- open-window [opts]
  "Creates a new window and buffer, returns the window and buffer ID"
  (let [open-term (-> (tab-get-open-terms) a.last get-term-win)]
    (nvim.set_current_win open-term)
    (if (= (a.get opts :direction) :horizontal)
      (if open-term
        (nvim.command "rightbelow vnew")
        (do
          ;; New window at the very bottom, see CTRL-W_J
          (nvim.command "botright new")
          (nvim.win_set_height 0 (a.get opts :size))))
      (if open-term
        (nvim.command "rightbelow new")
        (do
          ;; New window at the far right, see CTRL-W_L
          (nvim.command "vert botright new")
          (nvim.win_set_width 0 (a.get opts :size))))))

  (local win-id (nvim.get_current_win))
  (nvim.win_set_option win-id "number" false)
  (nvim.win_set_option win-id "relativenumber" false)
  (if (= (a.get opts :direction) :horizontal)
    (nvim.win_set_option win-id "winfixheight" true)
    (nvim.win_set_option win-id "winfixwidth" true))
  (let [buf-id (nvim.win_get_buf win-id)]
    (nvim.buf_set_option 12 :buflisted false)
    [win-id buf-id]))


(defn- check-term! [name]
  "Checks if the buffer associated with the term is still valid. Maybe it was
   manually closed by the user. If not valid, remove it from the table"
  (let [buf-id (a.get-in terms [name :buf])]
    (when (not (nvim.buf_is_valid buf-id))
      (a.assoc terms name nil))))

(defn- term-destroy [name]
  (let [buf-id (a.get-in terms [name :buf])]
    (if (nvim.buf_is_valid buf-id)
      (nvim.buf_delete buf-id {:force true})))
  (a.assoc terms name nil))

(defn- move-cur-bottom! [name]
  (let [buf-id (a.get-in terms [name :buf])
        win-id (get-term-win name)
        lines (nvim.buf_line_count buf-id)]
    (nvim.win_set_cursor win-id [lines 1])))

(defn term-close [name]
  (let [name (or name :default)
        win-id (get-term-win name)]
    (when win-id
      (nvim.win_close win-id false))))

(defn term-stop [name]
  (term-close name)
  (let [name (or name :default)
        job-id (a.get-in terms [name :job])]
    (when job-id
      (vim.fn.jobstop job-id))))



(def- shell->script-name
  {"fish" "nterm.fish"})

(defn- script-path [shell]
  ; Hacky, until we have a solution for
  ; https://github.com/Olical/aniseed/issues/34
  (when (not nvim.g.nterm_path)
    (nvim.command "source ~/projects/nterm.nvim/plugin/nterm_nvim.vim"))

  (let [script (a.get shell->script-name shell)]
    (when script
      (.. nvim.g.nterm_path "/" script))))

(defn- show-popup
  [term-name exit-code cmd opts]
  (let [timeout opts.popup]
    (when (< 0 timeout)
      (let [ok (= 0 exit-code)
            msg (if ok
                    ["OK!"
                     (.. "Terminal: " term-name)
                     (.. "Cmd: " cmd)]
                    [(.. "ERROR CODE: " exit-code)
                     (.. "Terminal: " term-name)
                     (.. "Cmd: " cmd)])]
        (ui.popup msg {:timeout timeout
                       :pos opts.popup_pos
                       :hl (if ok "NtermSuccess" "NtermError")})))))

(defn process-client-response
  [data]
  (let [(name exit-code term-cmd) (-> data
                                      (s.trim)
                                      (s.split "\r\n")
                                      (unpack))
        exit-code (tonumber exit-code)
        {:cmd cmd :opts opts} (a.get-in terms [name :current-cmd] {})
        opts (a.merge options (or opts {}))]
    (when (= cmd term-cmd) ;; Only if the cmd was send by the plugin
      (show-popup name exit-code cmd opts)
      (a.assoc-in terms [name :current-cmd] nil)

      (when (and (= 0 exit-code)
                 (< 0 opts.autoclose))
        (vim.defer_fn
          #(when (a.nil? (a.get-in terms [name :current-cmd]))
             (term-close name))
          opts.autoclose))
      {:name name
       :code exit-code})))



(defn init-server []
  (if (a.nil? (. _G "nterm_server"))
    (do
      (global nterm_server (server-utils.create-server "0.0.0.0" 0 process-client-response))
      (global nterm_port (a.get (nterm_server:getsockname) :port)))
    (do
      (nterm_server:close)
      (global nterm_server (server-utils.create-server "0.0.0.0" nterm_port process-client-response)))))



(defn- term-new [name opts]
  "Creates a terminal in a new window"
  (let [[win-id buf-id] (open-window opts)
        shell (a.get opts :shell)
        script (script-path shell)
        ; cmd (.. shell ";#" name)
        extra-args (if script (.. " -C 'source " script "'") "")
        cmd (.. shell extra-args)]

    (nvim.buf_set_option buf-id :filetype filetype)
    (nvim.buf_set_var buf-id "nterm_name" name)
    ; On exit the process, delete buffer and window
    (local job-id (vim.fn.termopen cmd {:on_exit #(term-destroy name)
                                        :env {:SHELL shell
                                              :NTERM_PORT (a.get (nterm_server:getsockname) :port)
                                              :NTERM_NAME name}}))
    ; Move cursor to the bottom
    (nvim.win_set_cursor win-id [(nvim.buf_line_count buf-id) 1])
    (a.assoc terms
             name
             {:name name
              ; :win win-id
              :buf buf-id
              :cmds []
              :current-cmd nil
              :job job-id})))

(defn- term-display [name opts]
  "Open an exising terminal"
  (let [buf-id (a.get-in terms [name :buf])
        [win-id old-buf-id] (open-window opts)]
        ; old-buf-id (nvim.win_get_buf win-id)]
    (nvim.command "wincmd p")
    (nvim.win_set_buf win-id buf-id)
    (nvim.buf_delete old-buf-id {})))


(defn term-open [name opts]
  "Opens a term, if not opened yet.
   It creates a new terminal process if the term with the current name doesn't
   exits"
  (let [name (or name :default)
        opts (or opts options)
        _ (check-term! name)
        cur-win (nvim.tabpage_get_win 0)
        term-buf-id (a.get-in terms [name :buf])]
    (if term-buf-id
      (when (not (get-term-win name))
        (term-display name opts))
      (term-new name opts))
    (nvim.set_current_win cur-win)))

(defn term_toggle [opts]
  (let [opts (a.merge options (or opts {}))
        open-terms (tab-get-open-terms)]
    (if (< 0 (a.count open-terms))
      (do
        (set nvim.g._nterm_terms open-terms)
        (a.run! term-close open-terms))
      (a.run! #(term-open $ opts) (or nvim.g._nterm_terms [:default])))))

;; TODO Move to other NS?

;;; MAPS
(defn add-maps []
  (let [opts {:noremap true
              :silent false}]
    (nvim.set_keymap "n" "<leader>tt" "<cmd>lua require'nterm.main'.term_toggle()<cr>" opts)
    (nvim.set_keymap "n" "<leader>tl" "<cmd>lua require'nterm.main'.term_send_cur_line()<cr>" opts)
    (nvim.set_keymap "n" "<leader>tf" "<cmd>lua require'nterm.main'.term_focus()<cr>" opts)))

(defn add-git-maps []
  (let [opts {:noremap true
              :silent false}]
    (nvim.set_keymap "n" "<leader>gpp" "<cmd>lua require'nterm.main'.term_send('git push', 'git')<cr>" opts)
    (nvim.set_keymap "n" "<leader>gps" "<cmd>lua require'nterm.main'.term_send('git push --set-upstream origin HEAD', 'git')<cr>" opts)
    (nvim.set_keymap "n" "<leader>gpf" "<cmd>lua require'nterm.main'.term_send('git push --force-with-lease', 'git')<cr>" opts)
    (nvim.set_keymap "n" "<leader>gpt" "<cmd>lua require'nterm.main'.term_send('git push --tags', 'git')<cr>" opts)
    (nvim.set_keymap "n" "<leader>gpu" "<cmd>lua require'nterm.main'.term_send('git pull --ff-only', 'git')<cr>" opts)
    (nvim.set_keymap "n" "<leader>gt" "<cmd>lua require'nterm.main'.term_focus('git')<cr>" opts)))

(defn init [user-options]
  (let [user-options (or user-options {})]
    (a.merge! options  user-options))
  (when options.maps
    (add-maps)
    (add-git-maps))
  (init-server)
  (def- loaded? true))

;;;


; TODO if the term doens't exist, wait until ready to send data
(defn term_send [cmd name opts]
  (let [name (or name :default)
        opts (a.merge options (or opts {}))]
    (when (= false loaded?)
      (init))
    (term-open name opts)
    (move-cur-bottom! name)
    (if (not= nil (a.get-in terms [name :current-cmd]))
      (ui.popup
        ["Command running in" (.. "terminal " name)]
        {:hl "NtermError" :pos opts.popup_pos})
      (let [size (nvim.fn.chansend
                   (a.get-in terms [name :job])
                   (.. cmd "\n"))]
        (when (< 0 size)
          (a.assoc-in terms [name :current-cmd] {:cmd cmd :opts opts})
          ; Save all commands
          (let [cmds (a.get-in terms [name :cmds])]
            (table.insert cmds cmd)))))))

(defn term_focus [name opts]
  (let [name (or name :default)
        opts (a.merge options (or opts {}))]
    (term-open name opts)
    (nvim.set_current_win (get-term-win name))
    (vim.cmd "startinsert")))


(defn- trim-with-pos [str]
  "Removes whitespace from both ends of the current line.
   Returns the text, the position of the first and the last non-whitespace characters"
  (let [line (s.trim str)
        (_ start-pos) (string.find str "^%s*(.-)")
        end-pos (+ (length line) start-pos)]
    [line start-pos end-pos]))

; :help setreg
; rtype = 'c'
; rtype = 'l'
; rtype = 'b'
(defn- highlight [start end rtype]
  (let [ns (nvim.create_namespace "")
        buf (nvim.get_current_buf)
        rtype (or rtype "c")]
    (vim.highlight.range buf ns "IncSearch" start end rtype)
    (vim.defer_fn #(nvim.buf_clear_namespace buf ns (a.first start) (a.inc (a.first end)))
                  500)))


(defn term_send_cur_line [name]
  (let [line-nr (a.dec (vim.fn.line "."))
        [line col-start col-end] (trim-with-pos (nvim.get_current_line))]
    (highlight [line-nr col-start] [line-nr col-end])
    (term_send line name)))


(comment
  ;; Public api
  (init)
  (get-terms)
  (term_toggle)

  ;; Following fns accept an optional extra parameter, term-name. Defaults to :default
  (term_send "ls")
  (term_send "ls" :foo)
  (term_send_cur_line)
  (term-open)
  (term-close)
  (term-stop)

  ;;
  ;; Internal API
  (get-term-win :default)
  (tab-get-open-terms)

  ;; Playground
  (get-terms)
  (term-open)
  (term-open :foo)
  (term-open :bar)
  (nvim.set_current_win 1318)
  (term_send "sleep 1; true" :default {:popup_pos :NW :popup 1000 :autoclose 1000})
  (term_send "sleep 2; false" :default))
