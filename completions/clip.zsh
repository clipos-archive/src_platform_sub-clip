# SPDX-License-Identifier: LGPL-2.1-or-later
# Copyright © 2017-2018 ANSSI. All Rights Reserved.
if [[ ! -o interactive ]]; then
    return
fi

compctl -K _clip clip

_clip() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(clip commands)"
  else
    completions="$(clip completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
