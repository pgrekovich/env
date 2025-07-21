source /opt/homebrew/opt/spaceship/spaceship.zsh
source "$HOME/.config/zsh/zsh-z/zsh-z.plugin.zsh"

export BAT_THEME=Dracula

alias l='eza'
alias ld='eza -lD'
alias lf='eza -lF --color=always | grep -v /'
alias lh='eza -dl .* --group-directories-first'
alias ll='eza -al --group-directories-first'
alias ls='eza -alF --color=always --sort=size | grep -v /'
alias lt='eza -al --sort=modified'

alias cat='bat --paging=never'

alias ..='cd ..'

alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias vimdiff="nvim -d"

alias dfstow='stow --dir="$HOME/.dotfiles/config" --target="$HOME" *'

alias docker="export TMPDIR=/tmp && docker"
alias yt1080="yt-dlp -f 'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"

source $HOME/.envs


tunnel() {
  local target=$1

  case "$target" in
    prod|dev|uat)
      ssh -N -v "demoboost-$target"
      ;;
    *)
      echo "❌ Unknown target: '$target'"
      echo "✅ Usage: tunnel [prod|dev|uat]"
      ;;
  esac
}

# # NOTE: FZF
# # Set up fzf key bindings and fuzzy completion
# eval "$(fzf --zsh)"
#
# export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#
# alias fdd="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
# export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
#
# # Setup fzf previews
# export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
# export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"
#
# # fzf preview for tmux
# export FZF_TMUX_OPTS=" -p90%,70% "
#


# LazyGit intregration, change folder after exit
lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}



server () {
  local port=${1:-8080}
  if [[ $port -eq 80 ]]; then
    sudo python3 -m http.server $port
  else
    python3 -m http.server $port
  fi
}

if [ -z "$SSH_AUTH_SOCK" ]; then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
   if [ "$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &> $HOME/.ssh/ssh-agent
   fi
   eval `cat $HOME/.ssh/ssh-agent`
   ssh-add ~/.ssh/juro-github
fi


export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
