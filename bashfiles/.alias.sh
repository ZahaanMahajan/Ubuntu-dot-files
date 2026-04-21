# ============================================================
#  ~/.alias.sh  —  Bash Aliases & Shortcuts
# ============================================================


# ------------------------------------------------------------
#  NAVIGATION
# ------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'                        # go back to previous directory

alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'
alias docs='cd ~/Documents'
alias dev='cd ~/Developer'               # change to your projects root
alias work='cd ~/Work'                   # change to your work root


# ------------------------------------------------------------
#  LISTING (ls)
# ------------------------------------------------------------
alias ls='ls --color=auto'
alias l='ls -CF'                         # compact, classifies entries
alias la='ls -A'                         # all files (no . and ..)
alias ll='ls -alFh'                      # long list, human-readable sizes
alias lh='ls -lh'                        # long list, human sizes
alias lt='ls -lth'                       # sort by newest first
alias lS='ls -lSh'                       # sort by largest first
alias ldir='ls -d */'                    # list directories only


# ------------------------------------------------------------
#  FILE OPERATIONS
# ------------------------------------------------------------
alias cp='cp -iv'                        # confirm + verbose
alias mv='mv -iv'                        # confirm + verbose
alias rm='rm -Iv'                        # confirm before mass deletes
alias mkdir='mkdir -pv'                  # make parent dirs, verbose
alias ln='ln -v'                         # verbose symlinks
alias mkd='mkdir -pv'                    # quick alias

# Safe copy with progress (requires rsync)
alias cpv='rsync -ah --info=progress2'


# ------------------------------------------------------------
#  CLIPBOARD & FILE CONTENT COPYING
# ------------------------------------------------------------
# Requires: sudo apt install xclip
alias copy='xclip -selection clipboard <'           # usage: copy file.txt
alias paste='xclip -selection clipboard -o'         # paste clipboard to stdout
alias showclip='xclip -selection clipboard -o'      # show clipboard contents
alias clearclip='echo -n "" | xclip -selection clipboard && echo "✔ Clipboard cleared"'

# Copy a file's contents with confirmation
cpy() {
    if [ -f "$1" ]; then
        xclip -selection clipboard < "$1"
        echo "✔ Copied contents of '$1' to clipboard ($(wc -l < "$1") lines)"
    else
        echo "✘ '$1' is not a file."
    fi
}

# Copy the absolute path of a file to clipboard
cppath() {
    realpath "$1" | xclip -selection clipboard
    echo "✔ Path copied: $(realpath "$1")"
}

# Copy output of any command to clipboard  — usage: ccopy ls -la
ccopy() { "$@" | xclip -selection clipboard && echo "✔ Output copied to clipboard"; }

# cat a file AND copy it at the same time
catcp() {
    if [ -f "$1" ]; then
        cat "$1" | tee /dev/tty | xclip -selection clipboard
        echo "✔ Contents also copied to clipboard."
    else
        echo "✘ '$1' is not a file."
    fi
}

# Diff two files and copy the result to clipboard
diffcp() { diff "$1" "$2" | xclip -selection clipboard && echo "✔ Diff copied to clipboard"; }


# ------------------------------------------------------------
#  SEARCH & FIND
# ------------------------------------------------------------
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Case-insensitive, recursive grep
alias grepi='grep -ri'

# Find files by name in current dir
alias ff='find . -type f -name'          # usage: ff "*.log"
alias fd='find . -type d -name'          # usage: fd "node_modules"

# Search running processes
alias psg='ps aux | grep -v grep | grep'


# ------------------------------------------------------------
#  DISK USAGE
# ------------------------------------------------------------
alias df='df -h'                         # human-readable disk free
alias du='du -h'                         # human-readable dir sizes
alias du1='du -h --max-depth=1'          # top-level sizes only
alias ducks='du -chs * | sort -rh | head -20'    # top 20 largest items


# ------------------------------------------------------------
#  SYSTEM & PROCESS
# ------------------------------------------------------------
alias top='top -o cpu'                   # sort by CPU by default
alias ps='ps aux'
alias kill9='kill -9'
alias ports='ss -tulnp'                  # show open ports
alias myip='curl -s https://ifconfig.me && echo'    # public IP
alias localip="hostname -I | awk '{print \$1}'"      # local IP

alias reboot='sudo reboot'
alias poweroff='sudo poweroff'
alias shutdown='sudo shutdown -h now'


# ------------------------------------------------------------
#  NETWORKING
# ------------------------------------------------------------
alias ping='ping -c 5'                   # ping 5 times then stop
alias wget='wget -c'                     # resume downloads by default
alias curl='curl -L'                     # follow redirects by default
alias headers='curl -I'                  # fetch HTTP headers only


# ------------------------------------------------------------
#  HISTORY
# ------------------------------------------------------------
alias h='history'
alias hg='history | grep'               # usage: hg ssh
alias hc='history -c'                   # clear history


# ------------------------------------------------------------
#  PACKAGE MANAGEMENT — apt (Debian/Ubuntu)
# ------------------------------------------------------------
alias apt='sudo apt'
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install -y'
alias remove='sudo apt remove -y'
alias purge='sudo apt purge -y'
alias autoremove='sudo apt autoremove -y'
alias search='apt search'


# ------------------------------------------------------------
#  GIT
# ------------------------------------------------------------
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gp='git push'
alias gpo='git push origin'
alias gpom='git push origin main'
alias gpl='git pull'
alias gplo='git pull origin'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gd='git diff'
alias gds='git diff --staged'
alias glog='git log --oneline --graph --decorate --all'
alias gst='git stash'
alias gstp='git stash pop'
alias gstc='git stash clear'
alias greset='git reset --hard HEAD'
alias gclean='git clean -fd'


# ------------------------------------------------------------
#  DOCKER
# ------------------------------------------------------------
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dstop='docker stop $(docker ps -q)'    # stop all containers
alias dclean='docker system prune -af'        # remove all unused objects
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'


# ------------------------------------------------------------
#  TMUX
# ------------------------------------------------------------
alias t='tmux'
alias ta='tmux attach'                        # attach to last session
alias tat='tmux attach -t'                    # usage: tat mysession
alias tn='tmux new-session'                   # new unnamed session
alias tns='tmux new-session -s'               # usage: tns mysession
alias tls='tmux list-sessions'                # list all sessions
alias tlw='tmux list-windows'                 # list windows in current session
alias tlp='tmux list-panes'                   # list panes in current window
alias tk='tmux kill-session'                  # kill current session
alias tkt='tmux kill-session -t'              # usage: tkt mysession
alias tka='tmux kill-server'                  # kill ALL sessions
alias ts='tmux switch -t'                     # usage: ts mysession
alias tr='tmux rename-session -t'             # usage: tr old new
alias td='tmux detach'                        # detach from session

# Windows
alias tnw='tmux new-window'                   # open a new window
alias trw='tmux rename-window'                # rename current window
alias tnx='tmux next-window'                  # go to next window
alias tpw='tmux previous-window'              # go to previous window

# Panes
alias tsp='tmux split-window -h'              # split pane side by side  (vertical bar)
alias tsh='tmux split-window -v'              # split pane top/bottom (horizontal bar)
alias tzp='tmux resize-pane -Z'               # zoom / unzoom current pane

# Config
alias tconf='vim ~/.config/tmux/tmux.conf'                # edit tmux config
alias treload='tmux source-file ~/.config/tmux/tmux.conf && echo "✔ tmux config reloaded"'

# Smart attach: attach if session exists, else create it
#   usage: tm          → session named "main"
#   usage: tm work     → session named "work"
tm() {
    local name="${1:-main}"
    tmux has-session -t "$name" 2>/dev/null \
        && tmux attach -t "$name" \
        || tmux new-session -s "$name"
}


# ------------------------------------------------------------
#  PYTHON
# ------------------------------------------------------------
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv venv'
alias activate='source venv/bin/activate'
alias deactivate='deactivate'
alias pipi='pip3 install'
alias pipr='pip3 install -r requirements.txt'


# ------------------------------------------------------------
#  NODE / NPM / YARN
# ------------------------------------------------------------
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nci='npm ci'
alias yi='yarn install'
alias ya='yarn add'
alias yr='yarn run'


# ------------------------------------------------------------
#  EDITORS
# ------------------------------------------------------------
alias vim='nvim'                          # always use neovim
alias nano='nano -w'                      # disable word-wrap
alias c='code .'                          # open VS Code in current dir
alias zed='zed .'                         # open Zed in current dir


# ------------------------------------------------------------
#  PRODUCTIVITY SHORTCUTS
# ------------------------------------------------------------
alias cls='clear'
alias q='exit'
alias path='echo -e ${PATH//:/\\n}'      # pretty-print PATH entries
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'                     # current week number
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# Quickly create and enter a directory
mkcd() { mkdir -p "$1" && cd "$1"; }

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1"   ;;
            *.tar.gz)   tar xzf "$1"   ;;
            *.tar.xz)   tar xJf "$1"   ;;
            *.bz2)      bunzip2 "$1"   ;;
            *.gz)       gunzip  "$1"   ;;
            *.rar)      unrar x "$1"   ;;
            *.zip)      unzip   "$1"   ;;
            *.7z)       7z x    "$1"   ;;
            *.tar)      tar xf  "$1"   ;;
            *)          echo "'$1' cannot be extracted automatically." ;;
        esac
    else
        echo "'$1' is not a valid file."
    fi
}

# Quick HTTP server in current directory
serve() { python3 -m http.server "${1:-8000}"; }

# Create a dated backup of a file
bak() { cp "$1" "${1}.$(date +%Y%m%d_%H%M%S).bak"; }

# Print a horizontal rule
hr() {
    local len="${1:-80}"
    local char="${2:--}"
    local line=""
    for ((i=0; i<len; i++)); do line+="$char"; done
    echo "$line"
}


# ------------------------------------------------------------
#  CONFIG FILE SHORTCUTS
# ------------------------------------------------------------
alias eal='vim ~/.alias.sh && source ~/.alias.sh'   # edit & reload aliases
alias bashrc='vim ~/.bashrc'                         # open .bashrc in nvim
alias aliases='vim ~/.alias.sh'                      # open .alias.sh in nvim
alias nbashrc='nano ~/.bashrc'                       # open .bashrc in nano
alias naliases='nano ~/.alias.sh'                    # open .alias.sh in nano
alias cbashrc='code ~/.bashrc'                       # open .bashrc in VS Code
alias caliases='code ~/.alias.sh'                    # open .alias.sh in VS Code

# Reload shell config
alias reload='source ~/.bashrc && echo "✔ Shell reloaded."'

# Reload configs without restarting terminal
alias rebash='source ~/.bashrc && echo "✔ .bashrc reloaded"'
alias realias='source ~/.alias.sh && echo "✔ .alias.sh reloaded"'

# View configs (read-only, paginated)
alias catbash='cat ~/.bashrc     | less'
alias cataliases='cat ~/.alias.sh  | less'

# ------------------------------------------------------------
#  BACKUP BASH CONFIG FILES
# ------------------------------------------------------------
# Copies ~/.bashrc and ~/.alias.sh to ~/.config/bashfiles/
# Creates the directory if it doesn't exist
 
BASH_BACKUP_DIR="$HOME/.config/bashfiles"
 
backupbash() {
    mkdir -p "$BASH_BACKUP_DIR"
    cp -v ~/.bashrc   "$BASH_BACKUP_DIR/.bashrc"
    cp -v ~/.alias.sh "$BASH_BACKUP_DIR/.alias.sh"
    echo "✔ Backed up to $BASH_BACKUP_DIR  [$(date '+%Y-%m-%d %H:%M:%S')]"
}
 
# Show what's inside the backup folder
alias lsbash='ls -lh "$BASH_BACKUP_DIR"'
 
# Open the backup folder
alias cdbash='cd "$BASH_BACKUP_DIR"'
 
# Quick-diff: compare live file vs backed-up file
diffbash() {
    echo "=== .bashrc diff ===" && diff ~/.bashrc "$BASH_BACKUP_DIR/.bashrc"; \
    echo "=== .alias.sh diff ===" && diff ~/.alias.sh "$BASH_BACKUP_DIR/.alias.sh"
}

# ============================================================
#  END OF .alias.sh
# ============================================================
