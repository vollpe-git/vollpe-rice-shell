pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
    readonly property var mainDevice: {
        let devices = Networking.devices.values;
        // console.log(devices);
        // for(let dev of devices){
        //     console.log(`${dev.name} : ${dev.state.toString()} -> type = ${dev.type} => ${dev}`);
        // }
        let activeDevices = devices.filter(d => d.state.toString() === "2");
        // console.log(`device attivi: ${activeDevices}`);
        let eth = activeDevices.find(d => d.type === 2);
        // console.log(`ethernet attivo : ${eth}`);
        if (eth)
            return eth;

        let wifi = activeDevices.find(d => d.type === 1);
        // console.log(`wifi: ${wifi}`);
        if (wifi)
            return wifi;

        if (activeDevices.length > 0)
            return activeDevices[0];
    }
    readonly property var devices: Networking.devices
}
