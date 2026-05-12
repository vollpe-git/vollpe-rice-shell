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
    delegate: PanelWindow {
        anchors {
            left: true
            right: true
            top: true
            bottom: true
        }
        required property ShellScreen modelData
    }
}
