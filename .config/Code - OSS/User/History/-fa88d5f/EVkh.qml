pragma Singleton
import Quickshell.Bluetooth

Singleton {
    property var adapters: Bluetooth.adapters
    property var defaultAdapter: Bluetooth.defaultAdapter
    property var devices: Bluetooth.devices
}
