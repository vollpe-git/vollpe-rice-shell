pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    property var adapters: Bluetooth.adapters
    property var defaultAdapter: Bluetooth.defaultAdapter
    property var devices: Bluetooth.devices

    onDevicesChanged: {
        console.log("devices changed");
        for (let dev of devices.values) {
            console.log(`${dev.name || dev.deviceName || "uknown name"}: ${dev.batteryAvailable ? dev.battery : "unavailable"}%`);
        }
    }
}
