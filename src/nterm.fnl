(module nterm
  {require {a aniseed.core
            s aniseed.string
            nvim aniseed.nvim}})

;; Plugin to interact with the neovim terminal

;; Every terminal gets assigned and unique human readable ID, we call it
;; term-name. In all the commands, if no ID is specified, the term-name used is
;; "default"

;; User can define some options:
;; - direction: how to open a terminal, horizontal or vertical
;; - size: Default size when a terminal is opened, in number of lines
;; - shell: Default shell when a new terminal is created
;; - bg_color: background color for the terminal

;; You can check if the VIM env variable exists to do different customization
;; in your shell for neoterm. (e.g.: display a different prompt inside neovim)

;; Exposed variables (can be read by plugins/custom scripts):
;; - b:neoterm_name (notice that the term-name is also appended to the buffer
;; name. Buffer name is shown with `:ls` or with the api
;; vim.api.nvim_buf_get_name(0)
;; - g:current_term: current active terminal. Commands are send here, unless a
;; term-name is explicitly passed

;; Concepts
;;


;; Functions
;; - (term-send line close-after term-name) => Sends a line to the term, openning
;; it if closed. close-after is the number of seconds to close the terminal
;; after a command is sucesfully executed. Default to -1 (don't close)
;; - (term_toggle) => toggle all terminals. If all closed will reopen all the previusly closed by this command
;; - (term-set-default term-name) => updates the default terminal
;; (term-set-autocmd cmd term-name) =>
;;
;; Low level exposed functions
;; (term-open term-name)
;; (term-close term-name)

;; Ideas

;; fuzzy finder to open a specific terminal(telescope integration?)
;; open in float window? maybe useful for 1 time run commands, like k9s or pspg


(def filetype :nterm)

(defonce terms {})

(def options
  {:size 20
   :direction :horizontal
   :shell "fish"
   :bg_color nil})

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


; (defn- term-get [name attr]
;   "Helper to get a terminal attribute"
;   (if attr
;     (a.get-in terms [name attr])
;     (a.get terms name)))

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

(defn- open-window []
  "Creates a new window and buffer, returns the window and buffer ID"
  (let [open-term (-> (tab-get-open-terms) a.last get-term-win)]
    (nvim.set_current_win open-term)
    (if (= (a.get options :direction) :horizontal)
      (if open-term
        (nvim.command "rightbelow vnew")
        (do
          ;; New window at the very bottom, see CTRL-W_J
          (nvim.command "botright new")
          (nvim.win_set_height 0 (a.get options :size))))
      (if open-term
        (nvim.command "rightbelow new")
        (do
          ;; New window at the far right, see CTRL-W_L
          (nvim.command "vert botright new")
          (nvim.win_set_width 0 (a.get options :size))))))

  (local win-id (nvim.get_current_win))
  (nvim.win_set_option win-id "number" false)
  (nvim.win_set_option win-id "relativenumber" false)
  [win-id (nvim.win_get_buf win-id)])


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

(defn- term-new [name]
  "Creates a terminal in a new window"
  (let [[win-id buf-id] (open-window)
        shell (a.get options :shell)
        cmd (.. shell ";#" name)]

    ; (local job-id (nvim.call_function "termopen" ["fish" {:clear_env true
    ;                                                       :env {:SHELL "fish"
    ;                                                             :FOO "BAR"}}]))
    (nvim.buf_set_option buf-id :filetype filetype)
    ; On exit the process, delete buffer and window
    (local job-id (vim.fn.termopen cmd {:on_exit #(term-destroy name)
                                        :env {:SHELL shell
                                              :FOO "BAR"}}))
    ; (nvim.command "wincmd p")
    (a.assoc terms
             name
             {:name name
              ; :win win-id
              :buf buf-id
              :job job-id})))

(defn- term-display [name]
  "Open an exising terminal"
  (let [buf-id (a.get-in terms [name :buf])
        [win-id old-buf-id] (open-window)]
        ; old-buf-id (nvim.win_get_buf win-id)]
    (nvim.command "wincmd p")
    (nvim.win_set_buf win-id buf-id)
    (nvim.buf_delete old-buf-id {})))


(defn term-open [name]
  "Opens a term, if not opened yet.
   It creates a new terminal process if the term with the current name doesn't
   exits"
  (let [name (or name :default)
        _ (check-term! name)
        cur-win (nvim.tabpage_get_win 0)
        term-buf-id (a.get-in terms [name :buf])]
    (if term-buf-id
      (when (not (get-term-win name))
        (term-display name))
      (term-new name))
    (nvim.set_current_win cur-win)))


(defn term-close [name]
  (let [name (or name :default)
        win-id (get-term-win name)]
    (when win-id
      (nvim.win_close win-id false))))


(defn term_toggle []
  (let [open-terms (tab-get-open-terms)]
    (if (< 0 (a.count open-terms))
      (do
        (set nvim.g._nterm_terms open-terms)
        (a.run! term-close open-terms))
      (a.run! term-open (or nvim.g._nterm_terms [:default])))))

; TODO if the term doens't exist, wait until ready to send data
(defn term-send [line name]
  (let [name (or name :default)]
    (term-open name)
    (nvim.fn.chansend
      (a.get-in terms [name :job])
      (.. line "\n"))))

(defn term_send_cur_line [name]
  (let [line (s.trim (nvim.get_current_line))]
    (term-send line name)))


;;; MAPS
(defn add-maps []
  (let [opts {:noremap true
              :silent false}]
    (nvim.set_keymap "n" "<leader>tt" "<cmd>lua require'nterm'.term_toggle()<cr>" opts)
    (nvim.set_keymap "n" "<leader>tl" "<cmd>lua require'nterm'.term_send_cur_line()<cr>" opts)))


(defn init [options]
  (add-maps))


(comment
  ;; Public api
  (def term-name? :default)

  (get-terms)
  (term_toggle)
  ;; Following fns accept an optional extra parameter, term-name. Defaults to :default
  (term-open)
  (term-close)
  (term-send "ls")
  (term_send_cur_line)

  ;;
  ;; Internal API
  (get-term-win)
  (tab-get-open-terms)

  ;; Playground
  (get-terms)
  (term-open :foo)
  (term-open :bar)
  (nvim.set_current_win 1318)
  (term-send "ls"))

