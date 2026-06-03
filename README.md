# vollpe-rice-shell
vollpe's personal hyprland rice
this i my personal hyprland personalization and it is only tested on my personal device and built around my needs and preferences.
This is suppoused to be an example repo more than a ready to use rice so do not copy and paste all the files in your home directory without testing first.

[![Watch the video demo here!](https://youtube.com)](https://youtu.be/xbEfn9WFb7Q)

## Dependencies and Tools

| Name | Type | Description |
| :--- | :--- | :--- |
| **hyprland** | Required | Core Window Manager |
| **quickshell** | Required | Main UI framework (Top bar, popups, notifications, and notes) |
| **kitty** | Required | Default terminal emulator |
| **fish** | Required | User-friendly command-line shell |
| **rofi** | Required | Application launcher and menu |
| **wlogout** | Required | Power menu utility |
| **hyprlock** | Required | Fast and secure screen locker |
| **hyprpaper** | Required | Fast wallpaper utility |
| **pipewire** | Required | Audio server backend |
| **fastfetch** | Required | System information display tool |
| **waybar** | Optional | Alternative lightweight top bar (less functionality) |
| **spicetify** (+ Spotify) | Optional | CLI tool for customizing the official Spotify client |
| **fresh** | Optional | Default text editor for config lists |
| **yazi** | Optional | Terminal file manager |
| **hyprshot** | Optional | Screenshot utility tool |
| **notify-send** | Optional | Desktop notification testing utility |

> **Note:** Dependencies marked as **Optional** are highly recommended to get the full experience out of this configuration but are not strictly required for the desktop environment to function.

## explaination
This repo is born because after i saw some rices (like caelestia, noctalia, dank-shell, and others) i wanted to build my own small ones with my needs.

## how to use
### installation
#### to copy all the files:
```bash
git clone https://github.com/vollpe-git/vollpe-rice-shell.git /tmp/vollpe-rice && cp -r /tmp/vollpe-rice/.config/* ~/.config/ && cp /tmp/vollpe-rice/.bashrc /tmp/vollpe-rice/.bash_profile ~ && rm -rf /tmp/vollpe-rice
```
<b>ATTENTION!! this command will overwrite all the config files that are present in this repo, so a backup is recommended to not lose some files</b>

#### to istall all the dependencies:
```bash
sudo pacman -S --needed hyprland kitty fish rofi wlogout hyprlock hyprpaper pipewire waybar yazi libnotify spotify-launcher fastfetch
yay -S --needed quickshell spicetify-cli hyprshot
```
### use
#### shortcuts:
| Keybinding | Action |
| :--- | :--- |
| `Super` + `Q` | Launch **Kitty** (Terminal) |
| `Super` + `C` | Close active window |
| `Super` + `M` | Exit **Hyprland** (Logout) |
| `Super` + `E` | Launch **Yazi** (File Manager) |
| `Super` + `V` | Toggle floating state for active window |
| `Super` + `R` | Launch **Rofi** (App Launcher) |
| `Super` + `P` | Toggle pseudo-tiling mode |
| `Super` + `J` | Toggle horizontal/vertical split orientation |
| `Super` + `T` | Launch **Firefox** (Web Browser) |
| `Super` + `Shift` + `A` | Launch **Fresh** (Text Editor) with apps list file |
| `Super` + `K` | Launch **Hyprpicker** (Color Picker) |
| `Super` + `Shift` + `S` | Take screenshot with **Hyprshot** |
| `Alt` + `F4` | Launch **Wlogout** (Power Menu) |
| `Super` + `Arrow Keys` | Move focus in the specified direction |
| `Super` + `Shift` + `Arrow Keys` | Move window in the specified direction |
| `Super` + `Ctrl` + `Arrow Keys` | Resize window in the specified direction |
| `Super` + `[0-9]` | Switch to workspace `[0-9]` |
| `Super` + `Shift` + `[0-9]` | Move active window to workspace `[0-9]` |
| `Super` + `G` | Toggle special workspace (scratchpad) |
| `Super` + `Shift` + `G` | Move active window to special workspace |
| `Super` + `F` | Toggle fullscreen mode |
| `Super` + `Z` | Center active window (useful for floating windows) |
| `Alt` + `Tab` | Switch to the last visited workspace |

#### Interface and UI

This dotfiles configuration features a fully custom interface powered by **Quickshell** and **Hyprland**, broken down into three main components:

##### 1. Top Bar
* **Left:** App launcher button (**Rofi**), Performance Monitor (CPU, RAM, Disk, Temp, and GPU/FPS via **MangoHUD**), Quick Launch menu, and Media Player.
* **Center:** **Hyprland** Workspace indicator.
* **Right:** 
  * **Volume Slider:** Click icon to mute, click percentage to round to the nearest multiple of 5, scroll or drag to adjust volume by steps of 5.
  * **Battery:** shows battery and time left to full or empty when hovering with mouse
  * **Bluetooth Menu:** Quick toggle and device settings popup.
  * **Network Settings:** Interface selection with Wi-Fi network scanning, connection, and disconnection management.
  * **Clock:** Current time and date.
  * **Power Menu:** Quick access button triggering **Wlogout**.

##### 2. Central Top Popup (Hover Trigger)
Hovering near the top-center of the screen opens a 2-tab menu:
* **Notifications Tab:** Click a notification to dismiss it, or use the bottom pink button to clear all.
* **Multi-Manager Tab:**
  * **Audio/Media:** Dropdown menus to select active media players, audio outputs, and inputs.
  * **System Tray:** Displays active tray apps (recording, calls, etc.). Right-click triggers the primary action; middle-click triggers the secondary action.
  * **Window Manager:** Shows open windows organized by workspace. Clicking a window brings it into focus.

##### 3. Left Sidebar (Quick Notes & Sketches)
A minimalist 2-button sidebar dedicated to fast productivity:
* **Text Notes Tab:** Quick scratchpad to write, copy, or delete text. Saving exports a timestamped file to `~/Documents/Notes`.
* **Sketchpad Tab:** Drawing canvas with 3 colors, an adjustable eraser, and 4 brush sizes. Supports clipboard copying, canvas clearing, and saving timestamped images to `~/Documents/Drawings`.
