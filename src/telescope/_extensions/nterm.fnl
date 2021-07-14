(module telescope._extensions.nterm
  {require {telescope :telescope
            finders :telescope.finders
            sorters :telescope.sorters
            actions :telescope.actions
            pickers :telescope.pickers
            a       :aniseed.core
            c       :telescope.command
            entry_display :telescope.pickers.entry_display
            state :telescope.state
            previewers :telescope.previewers
            putils :telescope.previewers.utils
            utils :telescope.utils
            nterm :nterm.main
            actions_state :telescope.actions.state
            conf :telescope.config}})

; (nterm-finder)

;; About the entry_maker values:
; ordinal is the value used for sorting
; display is the value used to display
; value, usually holds the original value you passed to the entry maker (but can be whatever)
; text is like what you'd see for quickfix list

(defn nterm-finder [user-opts]
  (let [opts (or user-opts {})
        ; conf (a.identity conf.values.generic_sorter)
        config {:prompt_title "nterm"
                :finder (finders.new_table
                          {:results (a.keys (nterm.get-terms))
                           :entry_maker (fn [line]
                                           {:ordinal  (a.get-in (nterm.get-terms) line :buf)
                                            :display  line})})
                :attach_mappings
                (fn [bufnr map]
                  (actions.select_default:replace
                    (fn [_ cmd]
                      (actions.close bufnr)
                      (nterm.term-open
                        (a.get (actions_state.get_selected_entry) :display)))

                    (map "i" "<c-e>"
                         (fn []
                           (actions.close bufnr)
                           (nterm.term-open (actions_state.get_current_line)))))
                  true)


                ; :previewer (previewers.new_buffer_previewer
                ;              {:title
                ;               "Nterm preview"
                ;               :define_preview
                ;               (fn [self entry status]
                ;                 (let [p (vim.fn.expand (.. "#" (a.get entry :ordinal) ":p"))]
                ;                   (conf.values.buffer_previewer_maker p self.state.bufnr {})))})



                :sorter (conf.values.generic_sorter)}]
    (: (pickers.new opts config) :find)))

(telescope.register_extension
  {:exports
   {:nterm #(let [opts (or $1 {})]
               (nterm-finder opts))}})
