(module nterm.server-utils
  {require {a aniseed.core
            s aniseed.string
            nvim aniseed.nvim}})

(defn- conn-handler [f]
  (fn [sock]
    (sock:read_start
       (fn [err data]
         (if data
           (do
             (vim.schedule #(f data))
             (sock:write "OK"))
           (sock:close))))))

(defn create-server [host port f]
  (let [server (vim.loop.new_tcp)]
    (server:bind host port)
    (server:listen 128
                   (fn [err]
                     (let [sock (vim.loop.new_tcp)
                           on-connect (conn-handler f)]
                        (server:accept sock)
                        (on-connect sock))))
    server))

(comment
  (print (.. "TCP server on port " (a.get (server:getsockname) :port)))
  (server:close))
  ;; to test it:
  ;; echo 'aa' | nc -N 0.0.0.0 $PORT
