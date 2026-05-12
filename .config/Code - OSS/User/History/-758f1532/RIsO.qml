pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    readonly property real cpuUsage: 0
    readonly property real ramUsage: 0
    readonly property real cpuTemp: 0
    readonly property real diskUsage: 0
    readonly property real gpuUsage: 0
    readonly property int fps: 0

    // Esempio per la RAM usando un Timer e un comando shell
    Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: ramCommand.start()
    }

    Process {
        id: ramCommand
        command: ["sh", "-c", "free -m --si | grep Mem | awk '{print $3/1000}'"]
        stdout: SplitParser {
            onRead: (line) => ramUsage = parseFloat(line).toFixed(1)
        }
        onExited: running = false
    }

    Process{
        id: cpuCommand
        command: ["sh", "-c", "top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}'"]
        stdout: SplitParser {
            onRead: (line) => cpuUsage = parseFloat(line).toFixed(1)
        }
        onExited: running = false
    }

    Process{
        id: diskCommand
        command: ["sh", "-c", "df | grep '/$' | awk '{print $3/$2*100}'"]
        stdout: SplitParser {
            onRead: (line) => diskUsage = parseFloat(line).toFixed(1)
        }
        onExited: running = false
    }

    Process{
        id: tempCommand
        command: ["sh", "-c", "cat /sys/class/thermal/thermal_zone0/temp | awk '{print $1/1000}'"]
        stdout: SplitParser {
            onRead: (line) => diskUsage = parseFloat(line).toFixed(1)
        }
        onExited: running = false
    }
}