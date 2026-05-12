pragma singleton
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
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

Item {
    property bool fastLauncherActive: false
    property point fastLauncherButtonPosition: Qt.point(0, 0)
}
