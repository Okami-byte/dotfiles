# Drop into fish if:
# - The parent process isn't fish.
# - Not running a command like `bash -c 'echo foo'`.
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} && ${SHLVL} == 1 ]]; then
  # Let fish whether it's a login shell.
  if ! shopt -q login_shell; then
    exec fish --login
  else
    exec fish
  fi
fi

eval "$(starship init bash)"
