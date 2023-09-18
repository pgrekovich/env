source "$HOME/.config/zsh/spaceship/spaceship.zsh"
source "$HOME/.config/zsh/zsh-z/zsh-z.plugin.zsh"
source "$HOME/.config/zsh/exa-zsh/exa-zsh.plugin.zsh"

eval "$(fnm env --use-on-cd)"

export GITHUB_TOKEN=xxx

alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias vimdiff="nvim -d"

alias yt1080="yt-dlp -f 'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'"

alias selfcontrol="./.scripts/selfcontrol.sh"

autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'



