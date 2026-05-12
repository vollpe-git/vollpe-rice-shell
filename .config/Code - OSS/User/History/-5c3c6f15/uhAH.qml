// qmllint disable unused-imports
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import qs.services
import qs.widgets
import qs.modules

Variants {
    model: Quickshell.screens
    delegate: Drawer {}
}
