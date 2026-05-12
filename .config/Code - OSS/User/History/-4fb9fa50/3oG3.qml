import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import "./services"
import "./widgets"
import "./modules"

    Rectangle {
        width: 100
        height: 100
        anchors.top: parent.top
        color: "#ffffff"
        x: 0
        y: 0
    }
    component TextChildIcon: Text {
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 12
        color: "white"
        // Layout.preferredWidth: 20
        // Puoi aggiungere qui tutto quello che vuoi sia comune
    }
    component TextChildInfo: Text {
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 10
        color: "white"
        Layout.preferredWidth: 40
        // Puoi aggiungere qui tutto quello che vuoi sia comune
    }
    component MediaControlIcon: Text {
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 10
        // color: "black"
    }
    ShellWindow {
        anchors.top: true
        anchors.left: true
        anchors.right: true
        height: 30
        color: '#0Aff7ef6'

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.centerIn: parent

            RowLayout { // sinistra
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10
                Rectangle { // rofi
                    implicitWidth: 30
                    implicitHeight: 30
                    radius: 15

                    Process {
                        id: rofi
                        command: ["rofi", "-show", "drun"]
                        onExited: running = false
                    }

                    Text {
                        topPadding: 3
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        text: "󰭟"
                        color: "#000000"
                        font.pixelSize: 25
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: rofi.running = true
                    }
                }

                GridLayout { // performance check
                    columns: 6
                    rowSpacing: 0
                    columnSpacing: 10

                    // linea 1
                    TextChildIcon {
                        text: ""
                    }
                    TextChildInfo {
                        text: SysInfo.cpuUsage + "%"
                    }

                    TextChildIcon {
                        text: "󰘚"
                    }
                    TextChildInfo {
                        text: SysInfo.ramUsage + "GB"
                    }

                    TextChildIcon {
                        text: ""
                    }
                    TextChildInfo {
                        text: SysInfo.gpuUsage + "%"
                        Layout.preferredWidth: -1
                    }

                    // linea 2
                    TextChildIcon {
                        text: ""
                    }
                    TextChildInfo {
                        text: SysInfo.cpuTemp + "°C"
                    }

                    TextChildIcon {
                        text: ""
                    }
                    TextChildInfo {
                        text: SysInfo.diskUsage + "%"
                    }

                    TextChildIcon {
                        text: "󰍹"
                    }
                    TextChildInfo {
                        text: SysInfo.fps == 0 ? "??" : SysInfo.fps + " FPS"
                        Layout.preferredWidth: -1
                    }
                }

                Rectangle { // most used app launcher
                    implicitHeight: 30
                    implicitWidth: implicitHeight
                    radius: implicitHeight / 2

                    Text {
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        color: "#000000"
                        font.pixelSize: 23
                        text: "󰣇"
                    }

                    // FastLaunch {
                    //     id: fastLaunchMenu

                    //     // Opzionale: posizionalo rispetto alla barra
                    //     // x: (parent.width / 2) - (width / 2) // Centrato orizzontalmente
                    //     // y: parent.height - 5                // 5px sotto la barra
                    // }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: fastLaunchMenu.visible = !fastLaunchMenu.visible
                    }
                }

                Rectangle { // media player
                    id: mediaPlayerRoot
                    property int pillInset: 4
                    implicitHeight: 30
                    implicitWidth: 300
                    radius: height / 2
                    color: '#ffffff'
                    RowLayout {
                        anchors.fill: parent
                        implicitHeight: mediaPlayerRoot.height
                        implicitWidth: mediaPlayerRoot.width
                        spacing: 10
                        anchors.verticalCenter: mediaPlayerRoot.verticalCenter
                        ClippingRectangle {
                            anchors.leftMargin: mediaPlayerRoot.pillInset
                            anchors.rightMargin: mediaPlayerRoot.leftMargin
                            implicitHeight: mediaPlayerRoot.implicitHeight - mediaPlayerRoot.pillInset
                            implicitWidth: implicitHeight
                            color: "black"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            radius: height / 2
                            Image {
                                source: Media.cover || ""
                                anchors.fill: parent

                                // --- LE PROPRIETÀ PER IL RIDIMENSIONAMENTO ---
                                fillMode: Image.PreserveAspectCrop
                                antialiasing: true

                                // Centra l'immagine nel caso venga ritagliata
                                horizontalAlignment: Image.AlignHCenter
                                verticalAlignment: Image.AlignVCenter
                            }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.rightMargin: mediaPlayerRoot.height / 2
                            spacing: 0
                            Text {
                                Layout.fillWidth: true
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 10
                                color: "black"
                                text: `${Media.title} - ${Media.artist}`
                            }
                            Slider {
                                Layout.fillWidth: true
                                implicitWidth: parent.width
                                visible: Media.timeBarFullSupport
                                value: (!Media.canSetPosition || !isUserInteracting) ? Media.position : value
                                maximum: Media.length
                                step: 5 //sec
                                dotSize: 0
                                dotColor: "transparent"
                                barThickness: 4
                                cutBar: false
                                accentColor: "black"
                                changeValueAfterMoved: true
                                handleSize: 4
                                onMoved: newValue => {
                                    Media.setPosition(newValue);
                                }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                MediaControlIcon { // shuffle
                                    text: "󰒟"
                                    color: {
                                        if (Media.shuffle == null)
                                            return "red";
                                        if (Media.shuffle)
                                            return "green";
                                        return "blue";
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Media.toggleRandom()
                                    }
                                }
                                MediaControlIcon { // back
                                    text: ""
                                    color: Media.activePlayer?.canGoPrevious ? "black" : '#57000000'
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Media.goPrevious()
                                    }
                                }
                                MediaControlIcon { // play/pause
                                    text: Media.activePlayer?.isPlaying ? "" : ""
                                    color: Media.activePlayer?.canTogglePlaying ? "black" : "#57000000"
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Media.togglePlay()
                                    }
                                }
                                MediaControlIcon { // next
                                    text: ""
                                    color: Media.activePlayer?.canGoNext ? "black" : '#57000000'
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Media.goNext()
                                    }
                                }
                                MediaControlIcon { // loop
                                    text: ""
                                    color: {
                                        if (Media.loop == null)
                                            return "red";
                                        else if (Media.loop == MprisLoopState.Track)
                                            return "green";
                                        else if (Media.loop == MprisLoopState.Playlist)
                                            return '#ff6600';
                                        else
                                            return "blue";
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Media.switchLoop()
                                    }
                                }

                                Item {
                                    Layout.fillWidth: true // Questo "spinge" tutto quello che viene dopo verso destra
                                }

                                Text { // minutaggio
                                    Layout.alignment: Qt.AlignRight
                                    color: "black"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 10
                                    text: `${Media.positionString}/${Media.lengthString}`
                                }
                            }
                        }
                    }
                }
            }

            RowLayout { // workspaces, centro
                spacing: 12
                //Layout.alignment: Qt.AlignCenter
                anchors.centerIn: parent

                Repeater {
                    // Filtriamo la lista dei workspace di Hyprland
                    model: {
                        let ids = [1, 2, 3];
                        for (let i = 0; i < Hyprland.workspaces.values.length; i++) {
                            let ws = Hyprland.workspaces.values[i];
                            if (ws.id > 3)
                                ids.push(ws.id);
                        }
                        return ids.sort((a, b) => a - b);
                    }

                    Text {
                        text: modelData

                        function getWorkspaceObject(id) {
                            for (let i = 0; i < Hyprland.workspaces.values.length; i++) {
                                let ws = Hyprland.workspaces.values[i];
                                if (ws.id === id)
                                    return ws;
                            }
                            return null;
                        }

                        readonly property var activeWs: getWorkspaceObject(modelData)

                        color: {
                            if (activeWs) {
                                if (activeWs.focused)
                                    return "#ff0000";
                                else if (activeWs.toplevels.values.length > 0)
                                    return "#00ff00";
                            } else
                                return "#ffffff";
                        }
                        font.bold: true
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Hyprland.dispatch("workspace " + modelData)
                        }
                    }
                }
            }

            RowLayout { //destra
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                RowLayout { // volume
                    spacing: 10

                    // PwObjectTracker{
                    //     id: sinkTracker
                    //     objects: Pipewire.defaultAudioSink && Pipewire.ready ? [Pipewire.defaultAudioSink] : []
                    // }

                    // readonly property var activeSink: sinkTracker.objects.length > 0 ? sinkTracker.objects[0] : null

                    Text { //icon
                        font.family: "JetBrainsMono Nerd Font"
                        // anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        lineHeight: 1.0
                        font.pixelSize: 19
                        color: "#ffffff"
                        text: {
                            if (Audio.muted)
                                return "󰝟";
                            else if (Audio.volume <= 0.33)
                                return "󰕿";
                            else if (Audio.volume <= 0.66)
                                return "󰖀";
                            else
                                return "󰕾";
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Audio.toggleSinkMute()
                        }
                    }

                    Text { // percentuale
                        font.family: "JetBrainsMono Nerd Font"
                        // anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        // anchors.horizontalCenter: parent.horizontalCenter
                        lineHeight: 1.0
                        font.pixelSize: 14
                        color: "#ffffff"
                        text: Math.round(Audio.volume * 100)
                        MouseArea { // round to nearest multiple of 5
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Audio.setVolume((Math.round((Audio.volume * 100) / 5) * 5) / 100);
                                volumeSlider.value = Audio.volume;
                            }
                        }
                    }

                    Slider {
                        id: volumeSlider
                        value: Audio.volume
                        width: 50
                        maximum: 1
                        handleSize: 10
                        step: 0.05
                        onMoved: newValue => {
                            // value = newValue;
                            Audio.setVolume(newValue);
                        // value = Audio.volume
                        // console.log(`newValue = ${newValue}, value = ${value}, volume = ${Audio.volume}`);
                        // console.log(`sink: ${Audio.sink?.nickname || Audio.sink?.description || Audio.sink?.name}, is the sink ready? ${Audio.sink?.ready}`);
                        // console.log("Il nuovo volume impostato è: " + newValue);
                        }
                    }
                }

                Rectangle { // bluetooth
                    implicitHeight: 30
                    implicitWidth: 30
                    radius: 15

                    readonly property bool bluetoothState: {
                        let state = false;
                        for (let adapter of Bluetooth.adapters.values) {
                            state = state || adapter.enabled;
                            // console.log(`adapter : ${adapter} -> state ${adapter.enabled ? "enabled" : "disabled"}`);
                        }
                        // console.log(`bluetooth state : ${state ? "enabled" : "disabled"}`);
                        return state;
                    }

                    readonly property bool bluetoothConnected: {
                        if (!bluetoothState)
                            return false;
                        let connected = false;
                        for (let dev of Bluetooth.devices.values) {
                            connected = connected || dev.connected;
                        }
                        // console.log(`bt connected? ${connected}`)
                        return connected;
                    }

                    Text {
                        font.family: "JetBrainsMono Nerd Font"
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        lineHeight: 1.0
                        font.pixelSize: 19

                        text: "󰂯"
                        color: {
                            if (parent.bluetoothConnected)
                                return "#00FF00"; // connected
                            if (parent.bluetoothState)
                                return "#0000FF"; // bt on
                            return "#FF0000"; // spento
                        }
                    }

                    Process {
                        id: bluetoothMenu
                        command: ["blueman-manager"]
                        onExited: running = false
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: bluetoothMenu.running = true// TODO bt devices menu
                    }
                }

                Rectangle { // wifi
                    implicitHeight: 30
                    implicitWidth: 30
                    radius: 15

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

                    Text {
                        font.family: "JetBrainsMono Nerd Font"
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        lineHeight: 1.0
                        font.pixelSize: 19
                        text: {
                            // if (parent.mainDevice) {
                            //     console.log("--- Proprietà disponibili per questo device ---");
                            //     for (let prop in parent.mainDevice) {
                            //         console.log(prop + " : " + parent.mainDevice[prop]);
                            //     }
                            // }
                            let dev = parent.mainDevice;
                            if (dev) {
                                if (dev.type === 2)
                                    return ""; // ethernet
                                if (dev.type === 1)
                                    return "󰖩"; // wifi
                                return "󰱓"; // altro
                            }
                            return "󱘖"; // disconnessa
                        }
                        color: '#000000'
                    }

                    Process {
                        id: connectionApp
                        command: ["kitty", "-e", "nmtui"]
                        onExited: running = false
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: connectionApp.running = true
                    }
                }

                Column { // orologio e data
                    anchors.verticalCenter: parent.verticalCenter

                    SystemClock {
                        id: clock
                        precision: SystemClock.Seconds
                    }

                    Text { // orario
                        color: "#ffffff"
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: (`${clock.hours.toString().padStart(2, "0")}:${clock.minutes.toString().padStart(2, "0")}:${clock.seconds.toString().padStart(2, "0")}`)
                    }

                    Text { //data
                        color: "#ffffff"
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: Qt.formatDate(clock.date, "ddd d/M/yyyy")
                    }
                }

                Rectangle { //power button
                    implicitWidth: 30
                    implicitHeight: 30
                    radius: 5

                    Process {
                        id: powerOptions
                        command: ["wlogout", "-b", "6"]
                        onExited: running = false
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "⏻"
                        color: "#000000"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: powerOptions.running = true
                    }
                }
            }
        }
    }
