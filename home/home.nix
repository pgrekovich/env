{ config, lib, pkgs, pkgs-unstable, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # Plain binary, not programs.neovim: that module writes its own
    # ~/.config/nvim/init.lua, which collides with the symlinked LazyVim config.
    # Unstable tracks upstream releases; stable pins at branch-release time.
    pkgs-unstable.neovim-unwrapped

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

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BAT_THEME = "Dracula";
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

      vi = "nvim";
      vim = "nvim";
      view = "nvim -R";
      vimdiff = "nvim -d";

      # regenerate ~/AGENTS.md after editing either agents file (see below)
      agents-sync = "cat ~/.dotfiles/config/agents/AGENTS.md ~/.dotfiles/config/agents/AGENTS.local.md > ~/AGENTS.md";

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
  # Only the one file: herdr keeps its sockets, logs and session state in the
  # same directory, so the directory itself can't be a symlink into the repo.
  home.file.".config/herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/herdr/.config/herdr/config.toml";
  # Same story one level down: the navigator plugin keeps jump-back state next
  # to its config, so only config.toml is linked.
  home.file.".config/herdr/plugins/config/herdr-navigator/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/herdr/.config/herdr/plugins/config/herdr-navigator/config.toml";

  home.file.".config/neovide/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/neovide/.config/neovide/config.toml";

  home.file.".finicky.js".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/finicky/.finicky.js";

  # macOS `login` greets every new shell with "Last login: ...". An empty
  # ~/.hushlogin is the documented way to silence it. Contents are irrelevant,
  # only the file has to exist.
  home.file.".hushlogin".text = "";

  # Agent instructions, two layers: the tracked AGENTS.md is the public base,
  # config/agents/AGENTS.local.md (gitignored, same pattern as zsh .envs) holds
  # private additions. ~/AGENTS.md is the merge of the two - a real file, not a
  # symlink, since no agent CLI has a portable include mechanism (codex has
  # none at all). Rebuilt on every switch; after editing either part without
  # switching, re-run the merge with the agents-sync alias.
  home.activation.mergeAgentsMd = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -f "${dotfiles}/config/agents/AGENTS.local.md" ]; then
      run /bin/sh -c "cat '${dotfiles}/config/agents/AGENTS.md' '${dotfiles}/config/agents/AGENTS.local.md' > \"$HOME/AGENTS.md\""
    else
      run /bin/sh -c "cat '${dotfiles}/config/agents/AGENTS.md' > \"$HOME/AGENTS.md\""
    fi
  '';
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/AGENTS.md";
}
