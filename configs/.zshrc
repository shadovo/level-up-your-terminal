# ─── Homebrew ─────────────────────────────────────────────────────────────────
# shellenv sets HOMEBREW_PREFIX, HOMEBREW_CELLAR, HOMEBREW_REPOSITORY and
# prepends Homebrew's bin/sbin to PATH, MANPATH, and INFOPATH.
# We capture HOMEBREW_PREFIX once here so we never need to spawn $(brew --prefix)
# as a subprocess again — every $BREW_PREFIX reference below is just a variable lookup.
eval "$(/opt/homebrew/bin/brew shellenv)"
BREW_PREFIX="$HOMEBREW_PREFIX"

# ─── Locale ───────────────────────────────────────────────────────────────────
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ─── Completions ──────────────────────────────────────────────────────────────
# Docs: https://zsh.sourceforge.io/Doc/Release/Completion-System.html
fpath=("$BREW_PREFIX/share/zsh/site-functions" ~/.zsh_functions $fpath)
autoload -Uz compinit && compinit
# zstyle controls completion behaviour. Docs: https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Control-Functions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' # case-insensitive matching
zstyle ':completion:*' menu select                                           # arrow-key navigable menu

# ─── Prompt ───────────────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ─── Plugins ──────────────────────────────────────────────────────────────────
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ─── fzf ──────────────────────────────────────────────────────────────────────
source <(fzf --zsh)

export FZF_DEFAULT_OPTS='--height ~60% --layout reverse --border --color=16'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

# ─── nvm ──────────────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$BREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

# ─── pnpm ─────────────────────────────────────────────────────────────────────
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ─── Local bin ─────────────────────────────────────────────────────────────────────
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# ─── Functions ────────────────────────────────────────────────────────────────────
autoload -Uz ~/.zsh_functions/*

# ─── Editors ──────────────────────────────────────────────────────────────────
export VISUAL="code"
export EDITOR="vim"

# ─── bat ──────────────────────────────────────────────────────────────────────
export BAT_THEME="Dracula"

# ─── History ──────────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY       # save timestamp and duration with each entry
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicate entries first when trimming
setopt HIST_IGNORE_DUPS       # don't record a command identical to the previous one
setopt HIST_IGNORE_SPACE      # don't record commands that start with a space
setopt HIST_VERIFY            # show the expanded history command before running it
setopt HIST_FIND_NO_DUPS      # skip duplicates when searching history (Ctrl-R)
setopt SHARE_HISTORY          # share history across all open terminal sessions

# ─── Colors ───────────────────────────────────────────────────────────────────
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad

# ─── Aliases ──────────────────────────────────────────────────────────────────
alias vi=vim
alias zshconfig="vim ~/.zshrc"

# ls: macOS ls does not colorize output by default — -G enables colors
alias ls='ls -G'
alias ll='ls -lAh'  # long format, all files including hidden, human-readable sizes
alias la='ls -A'    # all files except . and ..

# Directory navigation
alias 'cd..'='cd ..'
alias 'cd...'='cd ../../'
alias 'cd....'='cd ../../../'
alias 'cd.....'='cd ../../../../'

# Clear
alias cl='clear'
alias clea='clear'

# Finder
alias showHidden="defaults write com.apple.finder AppleShowAllFiles 1; killall Finder"
alias hideHidden="defaults write com.apple.finder AppleShowAllFiles 0; killall Finder"

# fd + fzf
alias fda='fd --type f --unrestricted | fzf'
alias fdf='fd --type f --hidden --exclude .git | fzf'
alias fdd='fd --type d --hidden --exclude .git | fzf'
