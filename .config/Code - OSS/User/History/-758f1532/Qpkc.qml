pragma Singleton
import Quickshell
import Quickshell.Io
import QtQml

Singleton {
    property real cpuUsage: 0
    property real ramUsage: 0
    property real cpuTemp: 0
    property real diskUsage: 0
    property real gpuUsage: 0
    property int fps: 0

    // Esempio per la RAM usando un Timer e un comando shell
    Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: {
            ramCommand.running = true;
            cpuCommand.running = true;
            diskCommand.running = true;
            tempCommand.running = true;
            gpuCommand.running = true;
            fpsCommand.running = true;
        } 
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
        command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print 100 - $8}'"]
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
            onRead: (line) => cpuTemp = parseFloat(line).toFixed(1)
        }
        onExited: running = false
    }

    Process{
        id: gpuCommand
        command: ["sh", "-c", "echo $(( $(cat /sys/class/drm/card1/device/mem_info_vram_used) * 100 / $(cat /sys/class/drm/card1/device/mem_info_vram_total) ))'"]
        stdout: SplitParser {
            onRead: (line) => gpuUsage = parseFloat(line).toFixed(1)
        }
        onExited: running = false
    }

    Process{
        id: fpsCommand
        command: ["sh", "-c", "[ -f /tmp/mangohud.log ] && tail -n 1 /tmp/mangohud.log | awk '{print $1}' || echo 0'"]
        stdout: SplitParser {
            onRead: (line) => fps = parseInt(line)
        }
        onExited: running = false
    }
}