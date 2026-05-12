pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    property var battery: UPower.displayDevice?.ready ? UPower.displayDevice : null
    property int percentage: battery?.percentage ?? -1
    property int health: battery?.healthSupported ? battery.healthPercentage : -1
    function timeToEmptyString() {
        if (battery?.timeToEmpty) {
            let min = Math.floor(battery.timeToEmpty / 60);
            let hours = Math.floor(min / 60);
            min -= hours * 60;
            let sec = Math.floor(battery.timeToEmpty % 60);
            sec = sec < 10 ? "0" + sec : sec;
            min = min < 10 ? "0" + min : min;
            return (`${hours}:${min}:${sec}`);
        } else {
            return "??:??:??";
        }
    }

    function timeToFullString() {
        if (battery?.timeToFull) {
            let min = Math.floor(battery.timeToFull / 60);
            let hours = Math.floor(min / 60);
            min -= hours * 60;
            let sec = Math.floor(battery.timeToFull % 60);
            sec = sec < 10 ? "0" + sec : sec;
            min = min < 10 ? "0" + min : min;
            return (`${hours}:${min}:${sec}`);
        } else {
            return "??:??:??";
        }
    }
}
