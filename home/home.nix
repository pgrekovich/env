{ config, pkgs, pkgs-unstable, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # daily cli
    eza
    bat
    ripgrep
    fd
    jq
    yazi
    htop
    wget
    yt-dlp
    ffmpeg

    # languages / clouds
    python3
    rustup
    awscli2

    # git tooling
    gh
    glab
    lazygit
    mergiraf

    # macos
    mas

    tmux

    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;

  # EDITOR is set by programs.neovim.defaultEditor
  home.sessionVariables = {
    BAT_THEME = "Dracula";
  };

  programs.neovim = {
    enable = true;
    # stable nixpkgs pins neovim at branch-release time; unstable tracks
    # upstream releases within days
    package = pkgs-unstable.neovim-unwrapped;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # fzf-tab loads at order 900: after compinit, before syntax highlighting
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    history = {
      size = 5000;
      share = true;
      ignoreSpace = true;
      ignoreAllDups = true;
      saveNoDups = true;
      findNoDups = true;
    };

    shellAliases = {
      l = "eza";
      ld = "eza -lD";
      lf = "eza -lF --color=always | grep -v /";
      lh = "eza -dl .* --group-directories-first";
      ll = "eza -al --group-directories-first";
      ls = "eza -alF --color=always --sort=size | grep -v /";
      lt = "eza -al --sort=modified";

      cat = "bat --paging=never";
      ".." = "cd ..";

      view = "nvim -R";
      vimdiff = "nvim -d";

      docker = "export TMPDIR=/tmp && docker";
      yt1080 = "yt-dlp -f 'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'";
    };

    initContent = ''
      # secrets live outside the repo, template: .envs.example
      [[ -f "$HOME/.envs" ]] && source "$HOME/.envs"

      bindkey -e
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no

      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];
  };

  # node/pnpm versions: global defaults here, per-project overrides
  # via .nvmrc / .node-version / mise.toml
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        node = "lts";
        pnpm = "latest";
      };
    };
  };

  programs.git = {
    enable = true;

    includes = [
      {
        condition = "gitdir:~/Projects/demoboost/**";
        path = "~/Projects/demoboost/.gitconfig";
      }
    ];

    settings = {
      user = {
        name = "Pavel Hrakovich";
        email = "pgrekovich@users.noreply.github.com";
      };

      alias = {
        current-branch = "!git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \\(.*\\)/\\1/'";
        a = "!git add . && git s";
        ch = "checkout";
        c = "commit -m";
        ac = "commit -am";
        s = "status --short --branch";
        d = "diff";
        l = "!git pull origin $(git current-branch) --rebase";
        h = "!git push origin $(git current-branch)";
        lh = "!git l && git h";
        r = "!git rm $(git ls-files --deleted) && git status";
        lg = "log --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset' --abbrev-commit";
      };

      core = {
        editor = "nvim";
        excludesfile = "~/.gitignore_global";
      };
      pull.rebase = true;
      merge.conflictStyle = "diff3";
      merge.mergiraf = {
        name = "mergiraf";
        driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
      };
    };
  };

  # Edit-in-place configs: the real files stay in the repo,
  # home locations just point at them. No rebuild needed after edits.
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/nvim/.config/nvim";
  home.file.".tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/tmux/.tmux.conf";
  home.file.".config/karabiner".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/karabiner/.config/karabiner";
  home.file.".config/ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/ghostty/.config/ghostty";
  home.file.".gitignore_global".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/git/.gitignore_global";
}
