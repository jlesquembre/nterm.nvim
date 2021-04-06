function _nterm_nvim --on-event fish_postexec
  set -l last_status $status
  printf "$NTERM_NAME\r\n$last_status\r\n$argv" | nc -N 0.0.0.0 $NTERM_PORT > /dev/null
end
