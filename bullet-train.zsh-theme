# README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
#
# In addition, I recommend the
# [Tomorrow Night theme](https://github.com/chriskempson/tomorrow-theme) and, if
# you're using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over
# Terminal.app - it has significantly better color fidelity.

# ------------------------------------------------------------------------------
# CONFIGURATION
# The default configuration, that can be overwrite in your .zshrc file
# ------------------------------------------------------------------------------
VIRTUAL_ENV_DISABLE_PROMPT=true

(($+BULLETTRAIN_PROMPT_SEGMENTS_ORDER)) || BULLETTRAIN_PROMPT_SEGMENTS_ORDER=(time status bg_jobs rvm virtualenv nvm context dir git)

# PROMPT
BULLETTRAIN_SHOW_PROMPT_CHAR=${BULLETTRAIN_SHOW_PROMPT_CHAR:-true}
BULLETTRAIN_PROMPT_CHAR=${BULLETTRAIN_PROMPT_CHAR:-\$}
BULLETTRAIN_PROMPT_ROOT=${BULLETTRAIN_PROMPT_ROOT:-true}

# STATUS
BULLETTRAIN_STATUS_SHOW=${BULLETTRAIN_STATUS_SHOW:-true}
BULLETTRAIN_STATUS_EXIT_SHOW=${BULLETTRAIN_STATUS_EXIT_SHOW:-false}
BULLETTRAIN_STATUS_BG=${BULLETTRAIN_STATUS_BG:-green}
BULLETTRAIN_STATUS_ERROR_BG=${BULLETTRAIN_STATUS_ERROR_BG:-red}
BULLETTRAIN_STATUS_FG=${BULLETTRAIN_STATUS_FG:-white}

# JOBS
BULLETTRAIN_BG_JOBS_SHOW=${BULLETTRAIN_BG_JOBS_SHOW:-true}
BULLETTRAIN_BG_JOBS_BG=${BULLETTRAIN_BG_JOBS_BG:-green}
BULLETTRAIN_BG_JOBS_FG=${BULLETTRAIN_BG_JOBS_FG:-white}

# TIME
BULLETTRAIN_TIME_SHOW=${BULLETTRAIN_TIME_SHOW:-true}
BULLETTRAIN_TIME_BG=${BULLETTRAIN_TIME_BG:-white}
BULLETTRAIN_TIME_FG=${BULLETTRAIN_TIME_FG:-black}

# VIRTUALENV
BULLETTRAIN_VIRTUALENV_SHOW=${BULLETTRAIN_VIRTUALENV_SHOW:-true}
BULLETTRAIN_VIRTUALENV_BG=${BULLETTRAIN_VIRTUALENV_BG:-yellow}
BULLETTRAIN_VIRTUALENV_FG=${BULLETTRAIN_VIRTUALENV_FG:-white}
BULLETTRAIN_VIRTUALENV_PREFIX=${BULLETTRAIN_VIRTUALENV_PREFIX:-🐍}

# NVM
BULLETTRAIN_NVM_SHOW=${BULLETTRAIN_NVM_SHOW:-false}
BULLETTRAIN_NVM_BG=${BULLETTRAIN_NVM_BG:-green}
BULLETTRAIN_NVM_FG=${BULLETTRAIN_NVM_FG:-white}
BULLETTRAIN_NVM_PREFIX=${BULLETTRAIN_NVM_PREFIX:-⬡ }

# RMV
BULLETTRAIN_RVM_SHOW=${BULLETTRAIN_RVM_SHOW:-true}
BULLETTRAIN_RVM_BG=${BULLETTRAIN_RVM_BG:-magenta}
BULLETTRAIN_RVM_FG=${BULLETTRAIN_RVM_FG:-white}
BULLETTRAIN_RVM_PREFIX=${BULLETTRAIN_RVM_PREFIX:-♦️}

# DIR
BULLETTRAIN_DIR_SHOW=${BULLETTRAIN_DIR_SHOW:-true}
BULLETTRAIN_DIR_BG=${BULLETTRAIN_DIR_BG:-blue}
BULLETTRAIN_DIR_FG=${BULLETTRAIN_DIR_FG:-white}
BULLETTRAIN_DIR_CONTEXT_SHOW=${BULLETTRAIN_DIR_CONTEXT_SHOW:-false}
BULLETTRAIN_DIR_EXTENDED=${BULLETTRAIN_DIR_EXTENDED:-true}
BULLETTRAIN_DIR_POWERLINE_STYLE=${BULLETTRAIN_DIR_POWERLINE_STYLE:-false}
BULLETTRAIN_DIR_CUR_FOLDER_FG=${BULLETTRAIN_DIR_CUR_FOLDER_FG:-white}

# GIT
BULLETTRAIN_GIT_SHOW=${BULLETTRAIN_GIT_SHOW:-true}
BULLETTRAIN_GIT_BG=${BULLETTRAIN_GIT_BG:-white}
BULLETTRAIN_GIT_FG=${BULLETTRAIN_GIT_FG:-black}
BULLETTRAIN_GIT_EXTENDED=${BULLETTRAIN_GIT_EXTENDED:-true}

# CONTEXT
BULLETTRAIN_CONTEXT_SHOW=${BULLETTRAIN_CONTEXT_SHOW:-false}
BULLETTRAIN_CONTEXT_BG=${BULLETTRAIN_CONTEXT_BG:-black}
BULLETTRAIN_CONTEXT_FG=${BULLETTRAIN_CONTEXT_FG:-default}

# GIT PROMPT
ZSH_THEME_GIT_PROMPT_PREFIX=${BULLETTRAIN_GIT_PREFIX:-"  "}
ZSH_THEME_GIT_PROMPT_SUFFIX=${BULLETTRAIN_GIT_SUFFIX:-}
ZSH_THEME_GIT_PROMPT_DIRTY=${BULLETTRAIN_GIT_DIRTY:- ✘}
ZSH_THEME_GIT_PROMPT_CLEAN=${BULLETTRAIN_GIT_CLEAN:- ✔}
ZSH_THEME_GIT_PROMPT_ADDED=${BULLETTRAIN_GIT_ADDED:-" %F{green}✚%F{black}"}
ZSH_THEME_GIT_PROMPT_MODIFIED=${BULLETTRAIN_GIT_MODIFIED:-" %F{blue}✹%F{black}"}
ZSH_THEME_GIT_PROMPT_DELETED=${BULLETTRAIN_GIT_DELETED:-" %F{red}✖%F{black}"}
ZSH_THEME_GIT_PROMPT_UNTRACKED=${BULLETTRAIN_GIT_UNTRACKED:-" %F{yellow}✭%F{black}"}
ZSH_THEME_GIT_PROMPT_RENAMED=${BULLETTRAIN_GIT_RENAMED:- ➜}
ZSH_THEME_GIT_PROMPT_UNMERGED=${BULLETTRAIN_GIT_UNMERGED:- ═}
ZSH_THEME_GIT_PROMPT_AHEAD=${BULLETTRAIN_GIT_AHEAD:- ⬆}
ZSH_THEME_GIT_PROMPT_BEHIND=${BULLETTRAIN_GIT_BEHIND:- ⬇}
ZSH_THEME_GIT_PROMPT_DIVERGED=${BULLETTRAIN_GIT_DIVERGED:- ⬍}

# ------------------------------------------------------------------------------
# SEGMENT DRAWING
# A few functions to make it easy and re-usable to draw segmented prompts
# ------------------------------------------------------------------------------

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# ------------------------------------------------------------------------------
# PROMPT COMPONENTS
# Each component will draw itself, and hide itself if no information needs
# to be shown
# ------------------------------------------------------------------------------

# Context: user@hostname (who am I and where am I)
context() {
  local user="$(whoami)"
  if [[ "$BULLETTRAIN_IS_SSH_CLIENT" ]]; then
    echo -n "${user}@%m"
  elif [[ "$user" != "$BULLETTRAIN_CONTEXT_DEFAULT_USER" ]]; then
    echo -n "${user}"
  fi
}
prompt_context() {
  [[ $BULLETTRAIN_CONTEXT_SHOW == false ]] && return

  local _context="$(context)"
  [[ -n "$_context" ]] && prompt_segment $BULLETTRAIN_CONTEXT_BG $BULLETTRAIN_CONTEXT_FG "$_context"
}

# Git
prompt_git() {
  if [[ $BULLETTRAIN_GIT_SHOW == false ]] then
    return
  fi

  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    prompt_segment $BULLETTRAIN_GIT_BG $BULLETTRAIN_GIT_FG

    if [[ $BULLETTRAIN_GIT_EXTENDED == true ]] then
      echo -n $(git_prompt_info)$(git_prompt_status)
    else
      echo -n $(git_prompt_info)
    fi
  fi
}

prompt_hg() {
  local rev status
  if $(hg id >/dev/null 2>&1); then
    if $(hg prompt >/dev/null 2>&1); then
      if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
        # if files are not added
        prompt_segment red white
        st='±'
      elif [[ -n $(hg prompt "{status|modified}") ]]; then
        # if any modification
        prompt_segment yellow black
        st='±'
      else
        # if working copy is clean
        prompt_segment green black
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}") $st
    else
      st=""
      rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null)
      if $(hg st | grep -Eq "^\?"); then
        prompt_segment red black
        st='±'
      elif $(hg st | grep -Eq "^(M|A)"); then
        prompt_segment yellow black
        st='±'
      else
        prompt_segment green black
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  if [[ $BULLETTRAIN_DIR_SHOW == false ]] then
    return
  fi

  local dir=''
  local _context="$(context)"
  [[ $BULLETTRAIN_DIR_CONTEXT_SHOW == true && -n "$_context" ]] && dir="${dir}${_context}:"
  [[ $BULLETTRAIN_DIR_EXTENDED == true ]] && dir="${dir}%4(c:...:)%3c" || dir="${dir}%1~"

  if [[ $BULLETTRAIN_DIR_POWERLINE_STYLE == true ]] then
    dir="$(print -P $dir)"
    dir_components=("${(@s,/,)dir}")
    # Last component is current folder which will be displayed in bold with a different color
    dir_components[-1]="%B%F{${BULLETTRAIN_DIR_CUR_FOLDER_FG}}$dir_components[-1]%b%K{$BULLETTRAIN_DIR_BG}"
    dir="${(j:  :)dir_components}"
  fi

  prompt_segment $BULLETTRAIN_DIR_BG $BULLETTRAIN_DIR_FG $dir
}

# RVM: only shows RVM info if on a gemset that is not the default one
prompt_rvm() {
  if [[ $BULLETTRAIN_RVM_SHOW == false ]] then
    return
  fi

  if which rvm-prompt &> /dev/null; then
    if [[ ! -n $(rvm gemset list | grep "=> (default)") ]]
    then
      prompt_segment $BULLETTRAIN_RVM_BG $BULLETTRAIN_RVM_FG $BULLETTRAIN_RVM_PREFIX"  $(rvm-prompt i v g)"
    fi
  fi
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  if [[ $BULLETTRAIN_VIRTUALENV_SHOW == false ]] then
    return
  fi

  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment $BULLETTRAIN_VIRTUALENV_BG $BULLETTRAIN_VIRTUALENV_FG $BULLETTRAIN_VIRTUALENV_PREFIX"  $(basename $virtualenv_path)"
  fi
}

# NVM: Node version manager
prompt_nvm() {
  if [[ $BULLETTRAIN_NVM_SHOW == false ]] then
    return
  fi

  [[ $(which nvm) != "nvm not found" ]] || return
  local nvm_prompt
  nvm_prompt=$(node -v 2>/dev/null)
  [[ "${nvm_prompt}x" == "x" ]] && return
  nvm_prompt=${nvm_prompt:1}
  prompt_segment $BULLETTRAIN_NVM_BG $BULLETTRAIN_NVM_FG $BULLETTRAIN_NVM_PREFIX$nvm_prompt
}

prompt_time() {
  if [[ $BULLETTRAIN_TIME_SHOW == false ]] then
    return
  fi

  prompt_segment $BULLETTRAIN_TIME_BG $BULLETTRAIN_TIME_FG %D{%H:%M:%S}
}

# Status:
# - was there an error
# - am I root
prompt_status() {
  if [[ $BULLETTRAIN_STATUS_SHOW == false ]] then
    return
  fi

  local symbols
  symbols=()
  [[ $RETVAL -ne 0 && $BULLETTRAIN_STATUS_EXIT_SHOW != true ]] && symbols+="✘"
  [[ $RETVAL -ne 0 && $BULLETTRAIN_STATUS_EXIT_SHOW == true ]] && symbols+="✘ $RETVAL"

  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡%f"

  if [[ -n "$symbols" && $RETVAL -ne 0 ]] then
    prompt_segment $BULLETTRAIN_STATUS_ERROR_BG $BULLETTRAIN_STATUS_FG "$symbols"
  elif [[ -n "$symbols" ]] then
    prompt_segment $BULLETTRAIN_STATUS_BG $BULLETTRAIN_STATUS_FG "$symbols"
  fi

}

# Background jobs
prompt_bg_jobs() {
  [[ $BULLETTRAIN_BG_JOBS_SHOW == true ]] || return
  [[ -n "$(jobs)" ]] && prompt_segment $BULLETTRAIN_BG_JOBS_BG $BULLETTRAIN_BG_JOBS_FG "⚙ %j"
}

# Prompt Character
prompt_char() {
  [[ $BULLETTRAIN_SHOW_PROMPT_CHAR == true ]] || return

  local bt_prompt_char

  if [[ ${#BULLETTRAIN_PROMPT_CHAR} -eq 1 ]] then
    bt_prompt_char="${BULLETTRAIN_PROMPT_CHAR}"
  fi

  if [[ $BULLETTRAIN_PROMPT_ROOT == true ]] then
    bt_prompt_char="%(!.%F{red}#.%F{green}${bt_prompt_char}%f)"
  fi

  echo -n "
%{${fg_bold[default]}%}${bt_prompt_char}"
}

# ------------------------------------------------------------------------------
# MAIN
# Entry point
# ------------------------------------------------------------------------------

build_prompt() {
  RETVAL=$?

  for segment in ${BULLETTRAIN_PROMPT_SEGMENTS_ORDER}; do
    eval "prompt_${segment}"
  done

  prompt_end
  prompt_char
}

PROMPT='
%{%f%b%k%}$(build_prompt) %{$reset_color%}'
