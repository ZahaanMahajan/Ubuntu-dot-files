# Bash Configuration

A modular, categorized set of Bash aliases and shell functions — organized into 20 topic files that are loaded automatically every time a shell starts.

---

## What Is This?

Instead of dumping every alias into `~/.bashrc` or a single monolithic `~/.bash_aliases`, this setup splits aliases into **20 numbered files** (`01-navigation.sh`, `02-listing.sh`, …, `20-backup.sh`) under `~/.aliases.d/`. A thin loader script (`~/.alias.sh`) sources them all in alphabetical order at shell startup.

This means:
- Each topic is easy to find and edit without scrolling through hundreds of lines.
- Adding a new alias category is as simple as dropping a new `NN-name.sh` file into `~/.aliases.d/`.
- Backups are versioned — the `backupbash` command snapshots the live configs into `~/.config/bashfiles/<timestamp>/` without ever overwriting a previous snapshot.

---

## How It Loads

```
~/.bashrc
  └── source ~/.alias.sh
        └── sources ~/.aliases.d/*.sh  (01 → 20, alphabetical)
```

`~/.bashrc` includes this at the bottom:

```bash
source ~/.alias.sh
```

`~/.alias.sh` is the loader:

```bash
ALIASES_DIR="$HOME/.aliases.d"
for _f in "$ALIASES_DIR"/*.sh; do
    [ -r "$_f" ] && source "$_f"
done
```

---

## File Layout

```
~/.config/bashfiles/
├── README.md                    # this file
├── latest/                      # most recent backup snapshot
│   └── aliases.d/
│       ├── 01-navigation.sh
│       ├── 02-listing.sh
│       └── … (20 files total)
└── 2026-04-21_141130/           # older timestamped snapshot
    └── aliases.d/
        └── … (same structure)

~/.aliases.d/                    # LIVE location — what the shell actually sources
│   ├── 01-navigation.sh
│   ├── 02-listing.sh
│   └── … (20 files total)
~/.alias.sh                      # loader — sources all of ~/.aliases.d/*.sh
```

> **Note:** The `~/.config/bashfiles/` directory stores **backups** of your live alias files. The shell sources from `~/.aliases.d/` directly. Use `backupbash` to snapshot the live configs here.

---

## Alias Modules

| File | Topic | Key aliases / functions |
|------|-------|------------------------|
| `01-navigation.sh` | Directory navigation | `..` `...` `~` `-` `dl` `dt` `dev` `mkcd` `bd` |
| `02-listing.sh` | `ls` variants | `l` `la` `ll` `lt` `lS` `ldir` `recent` `tree2` |
| `03-fileops.sh` | File operations | `cp` (safe) `mv` (safe) `rm` (safe) `cpv` `trash` |
| `04-clipboard.sh` | Clipboard | `copy` `paste` (xclip integration) |
| `05-search.sh` | Search | `ff` (find file) `ft` (find text) `fh` (history search) |
| `06-disk.sh` | Disk usage | `df` `du` `duh` `diskusage` |
| `07-system.sh` | System info | `meminfo` `cpuinfo` `psg` (grep processes) `killp` |
| `08-network.sh` | Networking | `myip` `localip` `ports` `pingg` |
| `09-history.sh` | Shell history | `h` `hg` (history grep) `hc` (clear history) |
| `10-apt.sh` | APT package manager | `apti` `aptr` `aptu` `aptuu` `apts` `aptl` |
| `11-git-status.sh` | Git file listing | `gll` `gllu` `glld` `glla` `gshow` |
| `12-git.sh` | Git shortcuts | `g` `gs` `gss` `ga` `gc` `gco` `gp` `gpl` `glog` `gdiff` |
| `13-docker.sh` | Docker shortcuts | `d` `dps` `di` `dc` `dcu` `dcd` `dcl` `dexec` |
| `14-tmux.sh` | tmux shortcuts | `t` `ta` `tn` `tns` `tls` `tk` `tka` `ts` `tr` `td` |
| `15-python.sh` | Python / pip / venv | `py` `pip` `venv` `activate` `pipi` `pipr` `mkvenv` |
| `16-node.sh` | Node / npm / yarn | `ni` `nid` `nr` `ns` `nb` `yi` `ya` |
| `17-editors.sh` | Editor shortcuts | `vim` → nvim, `c` → VS Code, `nano` (no wrap) |
| `18-productivity.sh` | General utilities | `cls` `q` `path` `now` `epoch` `extract` |
| `19-config.sh` | Edit configs | `eal` `ead` `bashrc` `aliases` `reload` |
| `20-backup.sh` | Alias backup system | `backupbash` `lsbackups` `restorebash` `diffbash` `cdbash` |

---

## Module Deep Dive

### Navigation (`01-navigation.sh`)

```bash
..        # cd ..
...       # cd ../..
~         # cd ~
-         # cd - (previous directory)
dl        # cd ~/Downloads
dev       # cd ~/Developer
mkcd dir  # mkdir -p dir && cd dir
bd name   # jump up to the nearest parent named "name"
```

### Listing (`02-listing.sh`)

```bash
ll        # ls -alFh  (long, human sizes)
lt        # ls -lth   (newest first)
lS        # ls -lSh   (largest first)
recent    # ls -lth | head -n 11  (10 most recently modified)
tree2     # tree -L 2 --dirsfirst -C  (tree2 3 for depth 3)
```

### File Operations (`03-fileops.sh`)

`cp`, `mv`, `rm` are aliased to their interactive/verbose variants (`-iv` / `-Iv`) so they always confirm before overwriting or mass-deleting. A `trash` function moves files to `~/.local/share/Trash/` instead of permanently deleting.

### Git (`12-git.sh` + `11-git-status.sh`)

```bash
gs        # git status
gss       # git status -s (compact)
ga        # git add
gaa       # git add --all
gc "msg"  # git commit -m "msg"
gco       # git checkout
gcb       # git checkout -b
gp        # git push
gpo       # git push origin
gpl       # git pull
glog      # pretty log (graph, one-line)
gll       # list all tracked files (green)
gllu      # list untracked files (red)
gshow     # full categorized status view
```

### Docker (`13-docker.sh`)

```bash
dps       # docker ps
dpsa      # docker ps -a
di        # docker images
dstop     # docker stop $(docker ps -q)  (all running)
dclean    # docker system prune -af
dc        # docker compose
dcu       # docker compose up -d
dcd       # docker compose down
dcl       # docker compose logs -f
dexec N   # exec into container N with bash (falls back to sh)
```

### tmux (`14-tmux.sh`)

```bash
t         # tmux
ta        # tmux attach
tns name  # tmux new-session -s name
tls       # tmux list-sessions
tkt name  # tmux kill-session -t name
td        # tmux detach
```

### Productivity (`18-productivity.sh`)

```bash
cls       # clear
q         # exit
path      # pretty-print $PATH (one entry per line)
now       # current date and time (YYYY-MM-DD HH:MM:SS)
epoch     # current Unix timestamp
extract   # auto-extract any archive (tar, zip, gz, bz2, xz, …)
```

### Config Reload (`19-config.sh`)

```bash
reload    # source ~/.bashrc && echo "✔ Shell reloaded."
eal       # edit ~/.alias.sh, then reload it
ead       # cd into ~/.aliases.d and open nvim
bashrc    # open ~/.bashrc in nvim
```

---

## Backup System (`20-backup.sh`)

Every call to `backupbash` creates a new **timestamped** snapshot — previous snapshots are never overwritten.

```
~/.config/bashfiles/
├── 2026-04-21_141130/    # older snapshot
│   └── aliases.d/
└── latest/               # most recent snapshot (symlink or copy)
    └── aliases.d/
```

### Commands

| Command | What it does |
|---------|-------------|
| `backupbash` | Snapshot `~/.bashrc`, `~/.alias.sh`, and `~/.aliases.d/` to a new `YYYY-MM-DD_HHMMSS` directory |
| `lsbackups` | List all snapshots in `~/.config/bashfiles/`, newest first |
| `restorebash [name]` | Restore from a snapshot (defaults to `latest`) — copies files back to `~` |
| `diffbash [name]` | Diff live configs against a snapshot to see what changed |
| `cdbash` | `cd` into the backup root `~/.config/bashfiles/` |

### Example workflow

```bash
# Before making changes, snapshot the live config
backupbash

# Edit aliases
vim ~/.aliases.d/12-git.sh

# Reload the shell to apply changes
reload

# If something broke, see what changed
diffbash latest

# Or restore the previous snapshot
restorebash 2026-04-21_141130
```

---

## Adding a New Alias File

1. Create a file in `~/.aliases.d/` following the naming convention:
   ```bash
   vim ~/.aliases.d/21-mytools.sh
   ```
2. Add your aliases and functions.
3. Reload the shell:
   ```bash
   reload
   ```

The loader picks up any `*.sh` file automatically — no registration needed.
