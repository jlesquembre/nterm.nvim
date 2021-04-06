(module nterm.ui
  {require {a aniseed.core
            s aniseed.string
            nvim aniseed.nvim}})

(defn- width []
  nvim.o.columns)

(defn- height []
  nvim.o.lines)


; Addapted from
; https://github.com/Olical/conjure/blob/a2298d12aaa2065f4a395f017ee1f3d392db283c/fnl/conjure/log.fnl#L105
(defn- popup-pos [anchor size]
  (let [north 2 west 2
        south (- (height) 4)
        east (- (width) 2)
        pos (-> (if
                  (= :NE anchor) {:row north :col east
                                  :box {:y1 north :x1 (- east size.width)
                                        :y2 (+ north size.height) :x2 east}}
                  (= :SE anchor) {:row south :col east
                                  :box {:y1 (- south size.height) :x1 (- east size.width)
                                        :y2 south :x2 east}}
                  (= :SW anchor) {:row south :col west
                                  :box {:y1 (- south size.height) :x1 west
                                        :y2 south :x2 (+ west size.width)}}
                  (= :NW anchor) {:row north :col west
                                  :box {:y1 north :x1 west
                                        :y2 (+ north size.height) :x2 (+ west size.width)}}
                  (do
                    (nvim.err_writeln "anchor must be one of: NE, SE, SW, NW")
                    (popup-pos :NE size)))
                (a.assoc :anchor anchor))]
    pos
    {:relative "editor" ; cursor, win, editor
     :width size.width
     :height size.height
     :col pos.col
     :row pos.row
     :focusable false
     :anchor pos.anchor
     :style "minimal"}))

(defn- max-length [xs]
  (math.max (unpack (a.map #(length $) xs))))

(def- default-options
  {:timeout 2000
   :hl "NtermSuccess"
   :pos "SE"})

;; msg can be a string or a list of strings
;; Options values:
;; :timeout => number in miliseconds
;; :pos => one of [:NE :SE :SW :NW]
;; :hl=> highlight group name
(defn popup [msg options]
  (let [options (a.merge default-options options)
        msg (if (a.string? msg) [msg] msg)
        lines (a.count msg)
        buf-id (nvim.create_buf true false)
        win-opts (popup-pos options.pos {:width (+ 2 (max-length msg)) :height (+ 2 lines)})
        win (nvim.open_win buf-id false win-opts)]
    (nvim.buf_set_lines buf-id 1 lines false (a.map #(.. " " $) msg))
    (nvim.win_set_option win "winblend" 10)
    (nvim.win_set_option win "winhl" (.. "Normal:" options.hl))
    (vim.defer_fn #(nvim.buf_delete buf-id {:force true})
                  options.timeout)
    win))


(defn- highlight [group guifg guibg ctermfg ctermbg attr guisp]
  (let [parts [group]]
    (when guifg (table.insert parts (.. "guifg=#" guifg)))
    (when guibg (table.insert parts (.. "guibg=#" guibg)))
    (when ctermfg (table.insert parts (.. "ctermfg=" ctermfg)))
    (when ctermbg (table.insert parts (.. "ctermbg=" ctermbg)))
    (when attr
      (table.insert parts (.. "gui=" attr))
      (table.insert parts (.. "cterm" attr)))
    (when guisp (table.insert parts (.. "guisp=#" guisp)))

    (nvim.command (.. "highlight " (table.concat parts " ")))))

(when (= 0 (nvim.fn.hlID "NtermSuccess"))
  (highlight "NtermSuccess" "181818" "a1b56c"))
(when (= 0 (nvim.fn.hlID "NtermError"))
  (highlight "NtermError" "d8d8d8" "ab4642"))


(comment
  (popup ["Success!"  "Command was ok"]
         {:timeout 2500
          :hl :NtermError
          ; :hl :NtermSuccess
          :pos :NW}))
