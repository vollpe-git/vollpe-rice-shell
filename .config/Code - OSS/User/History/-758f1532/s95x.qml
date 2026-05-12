pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    property real cpuUsage: 0
    property real ramUsage: 0
    property int cpuTemp: 0

    // Esempio per la RAM usando un Timer e un comando shell
    Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: ramCommand.start()
    }

    Process {
        id: ramCommand
        command: ["sh", "-c", "free | grep Mem | awk '{print $3/$2 * 100.0}'"]
        stdout: SplitParser {
            onRead: (line) => ramUsage = parseFloat(line).toFixed(1)
        }
    }
}