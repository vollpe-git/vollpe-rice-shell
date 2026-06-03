pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    // 1. Riferimento reattivo al displayDevice
    readonly property var battery: UPower.displayDevice?.ready ? UPower.displayDevice : null
    
    // 2. Le proprietà DEVONO essere binding pure. Niente assegnazioni JavaScript distruttive.
    // Usiamo l'operatore ternario in modo che QML sappia esattamente cosa tracciare.
    readonly property int percentage: (root.battery && root.battery.percentage !== undefined) ? Math.floor(root.battery.percentage * 100) : -1
    readonly property int health: root.battery?.healthSupported ? root.battery.healthPercentage : -1
    readonly property bool present: battery?.isLaptopBattery ? true : false
    readonly property bool charging: battery?.state == UPowerDeviceState.Charging ? true : false
    
    readonly property string timeLeft: {
        let _triggerEmpty = root.battery ? root.battery.timeToEmpty : 0;
        let _triggerFull = root.battery ? root.battery.timeToFull : 0;
    
        return root.charging ? root.timeToFullString() : root.timeToEmptyString()
    }

    // 3. Funzioni di formattazione del tempo pulite
    function timeToEmptyString(boolHours = true, boolMinutes = true, boolSeconds = false) {
        if (!root.battery || !root.battery.timeToEmpty) return "??:??:??";
        
        let totalSeconds = root.battery.timeToEmpty;
        let hours = Math.floor(totalSeconds / 3600);
        let min = Math.floor((totalSeconds % 3600) / 60);
        let sec = Math.floor(totalSeconds % 60);
        
        let stringTime = "~";
        if(boolHours) stringTime += `${hours}h`;
        //if(boolHours && boolMinutes || boolHours && boolSeconds) stringTime += ":";
        if(boolMinutes) stringTime += `${min.toString().padStart(2, '0')}m`
        //if(boolMinutes && boolSeconds) stringTime += ":";
        if(boolSeconds) stringTime += `${sec.toString().padStart(2, '0')}s`;
        //return `${hours}:${min.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`;
        return stringTime;
    }

    function timeToFullString(boolHours = true, boolMinutes = true, boolSeconds = false) {
        if (!root.battery || !root.battery.timeToFull) return "?";
        
        let totalSeconds = root.battery.timeToFull;
        let hours = Math.floor(totalSeconds / 3600);
        let min = Math.floor((totalSeconds % 3600) / 60);
        let sec = Math.floor(totalSeconds % 60);
        
        let stringTime = "";
        if(boolHours) stringTime += `${hours}`;
        if(boolHours && boolMinutes || boolHours && boolSeconds) stringTime += ":";
        if(boolMinutes) stringTime += `${min.toString().padStart(2, '0')}`
        if(boolMinutes && boolSeconds) stringTime += ":";
        if(boolSeconds) stringTime += sec.toString().padStart(2, '0');
        //return `${hours}:${min.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`;
        return stringTime;
    }
}