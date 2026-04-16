# KMonad Configuration

A system-level keyboard remapper that turns `Caps Lock` / `Left Ctrl` into a dual-purpose modifier: tap it for `Ctrl`, and hold it to activate a **Vim-style navigation layer** mapped over the whole keyboard.

---

## What is KMonad?

**KMonad** is a keyboard remapping daemon that runs at the Linux input-device level (via `uinput`). Unlike xmodmap or xkb, it works in any environment — X11, Wayland, or TTY. It intercepts raw key events and re-emits them with custom logic before they reach any application.

Think of it as QMK firmware for any keyboard, without needing to flash anything.

---

## What Does This Config Do?

The key insight of this setup is that `Caps Lock` is almost never used for its original purpose, but sits on a *prime location* on the home row. This config reassigns it:

- **Tap** `Caps Lock` → sends `Ctrl+[key]` for whatever key you press next while holding it
- **Hold** `Caps Lock` → activates the `ctrl-layer`, which turns your standard keyboard into a **control & navigation keyboard**

The same behavior is applied to **Left Ctrl** as well, so both keys activate the same layer.

### The `ctrl-layer` at a Glance

The most useful mappings in the `ctrl-layer` (accessed by holding `Caps Lock` or `Left Ctrl`):

| Hold `Caps` + | Sends | Normal use |
|---|---|---|
| `H` | `←` (Left arrow) | Vim left |
| `J` | `↓` (Down arrow) | Vim down |
| `K` | `↑` (Up arrow) | Vim up |
| `L` | `→` (Right arrow) | Vim right |
| `[` | `Esc` | Escape (Vim-friendly) |
| Any other key | `Ctrl + that key` | e.g. `Caps+C` → `Ctrl+C` |

This means you never have to move your hands off the home row to navigate with arrow keys.

---

## File Layout

```
~/.config/kmonad/
├── kmonad-template.kbd    # KMonad config with DEVICE_PATH placeholder
├── kmonad-launcher.sh     # Script that discovers keyboards and spawns KMonad per device
└── kmonad.service         # systemd user service that auto-starts the launcher
```

---

## Requirements

| Dependency | Why |
|---|---|
| **KMonad** binary | The remapping engine |
| **uinput** kernel module | KMonad uses it to emit synthetic key events |
| **udev rule** (optional) | Lets KMonad run as a non-root user |

### Installing KMonad

The recommended method is to download the prebuilt binary from the [KMonad releases page](https://github.com/kmonad/kmonad/releases) and place it at `~/.local/bin/kmonad`:

```bash
mkdir -p ~/.local/bin
# Replace <version> with the latest release, e.g. 0.4.3
curl -L https://github.com/kmonad/kmonad/releases/download/<version>/kmonad -o ~/.local/bin/kmonad
chmod +x ~/.local/bin/kmonad
```

Verify it works:
```bash
kmonad --version
```

### Enabling uinput Access (Important)

By default, only root can write to `/dev/uinput`. To allow your user to run KMonad without `sudo`:

```bash
# Add yourself to the input and uinput groups
sudo usermod -aG input,uinput $USER

# Create a udev rule that gives the uinput group write access
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' \
  | sudo tee /etc/udev/rules.d/90-uinput.rules

# Reload udev rules
sudo udevadm control --reload-rules && sudo udevadm trigger

# Log out and back in (or reboot) for group membership to take effect
```

---

## How the Launcher Works (`kmonad-launcher.sh`)

A single KMonad process can only manage **one** input device. If you use multiple keyboards (e.g., a laptop built-in keyboard and an external USB keyboard), you need one KMonad instance per device.

The launcher script automates this:

1. Scans every `/dev/input/event*` device.
2. Uses `udevadm` to check if the device is flagged as a keyboard (`ID_INPUT_KEYBOARD=1`).
3. Skips anything that looks like a mouse dongle.
4. For each real keyboard found, it copies `kmonad-template.kbd` to `/tmp/kmonad-configs/`, replaces the `DEVICE_PATH` placeholder with the actual device path (e.g. `/dev/input/event3`), and spawns a KMonad process in the background.
5. If no keyboards are found, it waits 5 seconds and tries again (handles race conditions at boot time).
6. Registers a `SIGTERM`/`SIGINT` handler to cleanly kill all spawned KMonad processes and clean up temp files when the service stops.

```
kmonad-launcher.sh
     │
     ├─ finds /dev/input/event3  (laptop keyboard)
     │     └─ creates /tmp/kmonad-configs/kmonad-event3.kbd
     │           └─ spawns kmonad kmonad-event3.kbd &
     │
     └─ finds /dev/input/event7  (USB keyboard)
           └─ creates /tmp/kmonad-configs/kmonad-event7.kbd
                 └─ spawns kmonad kmonad-event7.kbd &
```

---

## Setting Up the systemd Service

The `kmonad.service` file is a **systemd user service** (not a system service), so it runs under your own user account without elevated privileges.

### One-time Setup

```bash
# Link (or copy) the service file into the systemd user directory
mkdir -p ~/.config/systemd/user
ln -s ~/.config/kmonad/kmonad.service ~/.config/systemd/user/kmonad.service

# Reload the service manager to pick up the new file
systemctl --user daemon-reload

# Enable it so it starts automatically on login
systemctl --user enable kmonad.service

# Start it right now without rebooting
systemctl --user start kmonad.service
```

### Checking Status

```bash
systemctl --user status kmonad.service
```

You should see `active (running)`. If it failed, check the logs:

```bash
journalctl --user -u kmonad.service -n 50
```

### Stopping / Restarting

```bash
systemctl --user stop kmonad.service
systemctl --user restart kmonad.service
```

---

## The Keyboard Layout

### `defsrc` — the Physical Key Layout

`defsrc` tells KMonad which physical keys to intercept, in the order they appear on a standard ANSI keyboard. Every key listed here will be handled by KMonad (anything not listed falls through unchanged).

```
esc  f1  f2  f3  f4  f5  f6  f7  f8  f9  f10 f11 f12
grv  1   2   3   4   5   6   7   8   9   0   -   =   bspc
tab  q   w   e   r   t   y   u   i   o   p   [   ]   \
caps a   s   d   f   g   h   j   k   l   ;   '   ret
lsft z   x   c   v   b   n   m   ,   .   /   rsft
lctl lmet lalt        spc        ralt rmet cmp  rctl
```

### `defalias` — Shorthand Definitions

```lisp
(defalias
  cc (layer-toggle ctrl-layer)
)
```

`@cc` is a shorthand for "while held, activate `ctrl-layer`". This alias is used in both the `base` layer (for `Caps Lock`) and the `base` layer's `Left Ctrl`.

### `deflayer base` — Normal Typing

The `base` layer is what is active by default. It is identical to a normal keyboard *except*:

- **`Caps Lock`** is replaced by `@cc` — hold it to enter `ctrl-layer`
- **`Left Ctrl`** is also replaced by `@cc` — same behavior

```
…
caps → @cc   (was: Caps Lock)
…
lctl → @cc   (was: Left Ctrl)
```

Everything else types normally.

### `deflayer ctrl-layer` — Navigation & Ctrl Shortcuts

This layer is active only while `Caps Lock` or `Left Ctrl` is physically held down. The key mapping is:

```
h → Left    j → Down    k → Up    l → Right   (arrow keys, Vim-style)
[ → Esc                                        (Vim escape)
_ → (passthrough, key is ignored / stays as-is)
All other keys → Ctrl + that key               (e.g. hold Caps, press C → Ctrl+C)
```

Full layout of `ctrl-layer`:

| Physical key | Output in ctrl-layer |
|---|---|
| `H` | `←` Left arrow |
| `J` | `↓` Down arrow |
| `K` | `↑` Up arrow |
| `L` | `→` Right arrow |
| `[` | `Esc` |
| `Caps Lock` | `_` (pass-through / no-op while already in this layer) |
| `Left Ctrl` | `_` (same) |
| Any other key | `Ctrl + <key>` |

---

## Modifying the Config

To add or change a mapping, edit `kmonad-template.kbd` and then restart the service:

```bash
systemctl --user restart kmonad.service
```

> **Important:** Do NOT edit the generated files in `/tmp/kmonad-configs/` — they are overwritten every time the service starts. Always edit `kmonad-template.kbd`.

### KMonad Syntax Quick Reference

| Syntax | Meaning |
|--------|---------|
| `a` | Emit key `a` |
| `C-a` | Emit `Ctrl+A` |
| `_` | Pass-through (do not remap this key) |
| `XX` | Block this key (swallow and emit nothing) |
| `(layer-toggle foo)` | Hold to activate layer `foo` |
| `(tap-hold t h key1 key2)` | Tap → `key1`, hold > `t` ms → `key2` |
| `@alias` | Reference a previously defined alias |
