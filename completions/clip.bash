# SPDX-License-Identifier: LGPL-2.1-or-later
# Copyright © 2017-2018 ANSSI. All Rights Reserved.
_clip() {
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(clip commands)" -- "$word") )
  else
    local completions="$(clip completions "${COMP_WORDS[@]:1}")"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -o default -F _clip clip
