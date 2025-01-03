source "$HOME/.config/zsh/spaceship/spaceship.zsh"
source "$HOME/.config/zsh/zsh-z/zsh-z.plugin.zsh"

alias ..='cd ..'

alias l='eza'
alias ld='eza -lD'
alias lf='eza -lF --color=always | grep -v /'
alias lh='eza -dl .* --group-directories-first'
alias ll='eza -al --group-directories-first'
alias ls='eza -alF --color=always --sort=size | grep -v /'
alias lt='eza -al --sort=modified'

alias cat='bat --paging=never'
export BAT_THEME=Dracula

alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias vimdiff="nvim -d"

alias yt1080="yt-dlp -f 'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"

server () {
  local port=${1:-8080}
  if [[ $port -eq 80 ]]; then
    sudo python3 -m http.server $port
  else
    python3 -m http.server $port
  fi
}

export GITHUB_TOKEN=xxx
export GITLAB_TOKEN=xxx
export REGISTRY_TOKEN=$GITLAB_TOKEN
export OPENAI_API_KEY=xxx

eval "$(fnm env --use-on-cd)"

autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'



