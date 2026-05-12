pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    property var adapters: Bluetooth.adapters
    property var defaultAdapter: Bluetooth.defaultAdapter
    property var devices: Bluetooth.devices
}
