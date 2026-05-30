// qmllint disable unused-imports
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Networking
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import qs.services
import qs.widgets
import qs.modules

WrapperItem {
    id: root

    property int interModuleSpacing: 20

    // Component.onCompleted: {
    //     console.log("Inizializzo notifiche. Conteggio attuale: " + Notifications.notifications.values.lenght); // to wake up the notifications singleton
    // }

    anchors {
        top: parent.top
        right: parent.right
        left: parent.left
        // horizontalCenter: parent.horizontalCenter
    }

    component TextChildIcon: Text {
        font.family: theme.defaultFont
        font.pixelSize: 12
        color: "white"
        // Layout.preferredWidth: 20
        // Puoi aggiungere qui tutto quello che vuoi sia comune
    }
    component TextChildInfo: Text {
        font.family: theme.defaultFont
        font.pixelSize: 10
        color: "white"
        Layout.preferredWidth: 40
        // Puoi aggiungere qui tutto quello che vuoi sia comune
    }
    component MediaControlIcon: Text {
        font.family: theme.defaultFont
        font.pixelSize: 10
        // color: "black"
    }
    PanelWindow {
        id: rootPanelWindow
        anchors.top: true
        anchors.left: true
        anchors.right: true
        height: theme.barHeigth
        color: theme.bg2

        Rectangle {
            // DA MODIFICARE
            implicitWidth: Screen.width / 4
            anchors.horizontalCenter: parent.horizontalCenter
            // anchors.top: rootPanelWindow.top
            implicitHeight: 1
            color: "transparent"
            z: 10
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                // Azione quando il mouse ENTRA
                onEntered: {
                    Global.notificationPanelActive = true;
                }

                // Azione quando il mouse ESCE
                // onExited: {
                //     Global.notificationPanelActive = false;
                // }
            }
        }

        RowLayout {
            anchors.fill: parent
            // anchors.leftMargin: 10
            // anchors.rightMargin: 10
            anchors.margins: theme.barPadding
            anchors.centerIn: parent

            RowLayout { // sinistra
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: root.interModuleSpacing
                Rectangle { // rofi
                    implicitHeight: parent.implicitHeight
                    implicitWidth: implicitHeight
                    radius: implicitHeight / 2
                    color: theme.magenta2

                    Process {
                        id: rofi
                        command: ["rofi", "-show", "drun"]
                        onExited: running = false
                    }

                    Text {
                        topPadding: 3
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        font.family: theme.defaultFont
                        text: "󰭟"
                        color: theme.fg4
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
                    rowSpacing: 2
                    columnSpacing: 3
                    Layout.fillHeight: true

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
                    implicitHeight: parent.implicitHeight
                    implicitWidth: implicitHeight
                    radius: implicitHeight / 2
                    color: theme.bg

                    Text {
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        color: theme.fg
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
                        onClicked: {
                            var globalPos = parent.mapToGlobal(parent.width / 2, parent.height);
                            // globalPos.x += parent.width / 2;
                            Global.fastLauncherActive = !Global.fastLauncherActive;
                            Global.fastLauncherButtonPosition = globalPos;
                            console.log(globalPos);
                        }
                    }
                }

                Rectangle { // media player
                    id: mediaPlayerRoot
                    property int pillInset: 4
                    implicitHeight: parent.implicitHeight
                    implicitWidth: 300
                    radius: height / 2
                    color: theme.bg
                    RowLayout {
                        anchors.fill: parent
                        implicitHeight: mediaPlayerRoot.height
                        implicitWidth: mediaPlayerRoot.width
                        spacing: 10
                        anchors.verticalCenter: mediaPlayerRoot.verticalCenter
                        clip: true
                        ClippingRectangle {
                            id: albumArtContainer
                            height: mediaPlayerRoot.implicitHeight - mediaPlayerRoot.pillInset
                            width: height

                            anchors.leftMargin: mediaPlayerRoot.pillInset / 2
                            anchors.rightMargin: mediaPlayerRoot.leftMargin
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            radius: height / 2
                            color: "black"

                            Image {
                                id: coverImage
                                source: Media.cover || ""
                                anchors.fill: parent
                                fillMode: Image.PreserveAspectCrop
                                antialiasing: true
                                horizontalAlignment: Image.AlignHCenter
                                verticalAlignment: Image.AlignVCenter

                                // Sostituiamo NumberAnimation con RotationAnimation
                                RotationAnimation {
                                    id: vinylAnimation
                                    target: coverImage
                                    property: "rotation"

                                    // Definiamo un ciclo continuo completo da 0 a 360
                                    from: 0
                                    to: 360
                                    duration: 7500
                                    direction: RotationAnimation.Clockwise
                                    loops: Animation.Infinite

                                    // Non usiamo più la proprietà "running" specchiata direttamente,
                                    // ma usiamo un intercettore sui cambiamenti di stato del player
                                }

                                // Questo blocco monitora lo stato del player in tempo reale
                                // e mette in pausa/riprende l'animazione ESATTAMENTE dallo stesso grado
                                Connections {
                                    target: Media.activePlayer

                                    // Quando cambia lo stato di riproduzione
                                    function onIsPlayingChanged() {
                                        if (Media.activePlayer && Media.activePlayer.isPlaying) {
                                            // Se l'animazione era totalmente ferma, la startiamo, altrimenti riprende dal millisecondo esatto
                                            if (!vinylAnimation.running) {
                                                vinylAnimation.start();
                                            } else {
                                                vinylAnimation.resume();
                                            }
                                        } else {
                                            // Mette in pausa congelando la rotazione corrente senza resettarla
                                            vinylAnimation.pause();
                                        }
                                    }
                                }

                                // Sicurezza: se cambia traccia o il player si distrugge, resettiamo a 0
                                onSourceChanged: {
                                    vinylAnimation.stop();
                                    coverImage.rotation = 0;
                                    if (Media.activePlayer && Media.activePlayer.isPlaying) {
                                        vinylAnimation.start();
                                    }
                                }

                                // Il tuo pallino centrale (invariato)
                                Rectangle {
                                    id: centerDot
                                    height: parent.height / 4
                                    width: height
                                    radius: height / 2
                                    color: "#000000" // Ora puoi rimetterlo nero
                                    anchors.centerIn: parent
                                    z: 99
                                }
                            }
                        }
                        ColumnLayout {
                            id: mediaColumn
                            Layout.fillWidth: true
                            Layout.rightMargin: mediaPlayerRoot.height / 2
                            spacing: 0
                            Rectangle {
                                id: marqueeContainer
                                Layout.fillWidth: true
                                anchors.rightMargin: 20
                                height: longText.height
                                color: "transparent"
                                clip: true
                                Text {
                                    id: longText
                                    Layout.fillWidth: true
                                    font.family: theme.defaultFont
                                    font.pixelSize: 12
                                    color: theme.fg
                                    text: `${Media.title} - ${Media.artist}`
                                    font.bold: true
                                    onTextChanged: x = 0
                                    NumberAnimation on x {
                                        id: scrollAnim
                                        from: longText.paintedWidth > marqueeContainer.width ? marqueeContainer.width : 0                      // Parte da fuori schermo a destra
                                        to: -longText.paintedWidth                        // Finisce quando scompare a sinistra
                                        duration: (marqueeContainer.width + longText.paintedWidth) * 30 // Velocità costante (8ms per pixel)
                                        loops: Animation.Infinite                          // Ripete all'infinito
                                        running: longText.paintedWidth > marqueeContainer.width // Attiva solo se il testo è più lungo dell'area
                                    }
                                }
                            }
                            Slider {
                                id: mediaSlider
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
                                accentColor: theme.fg
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
                                        if (Media.shuffle == null || !Media.activePlayer?.shuffleSupported)
                                            return theme.bg;
                                        if (Media.shuffle)
                                            return theme.fg;
                                        return theme.fgOff;
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Media.toggleRandom()
                                    }
                                }
                                MediaControlIcon { // back
                                    text: ""
                                    color: Media.activePlayer?.canGoPrevious ? theme.fg : theme.fgOff
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Media.goPrevious()
                                    }
                                }
                                MediaControlIcon { // play/pause
                                    text: Media.activePlayer?.isPlaying ? "" : ""
                                    color: Media.activePlayer?.canTogglePlaying ? theme.fg : theme.fgOff
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Media.togglePlay()
                                    }
                                }
                                MediaControlIcon { // next
                                    text: ""
                                    color: Media.activePlayer?.canGoNext ? theme.fg : theme.fgOff
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Media.goNext()
                                    }
                                }
                                MediaControlIcon { // loop
                                    text: ""
                                    color: {
                                        if (Media.loop == null || !Media.activePlayer?.loopSupported)
                                            return theme.bg;
                                        else if (Media.loop == MprisLoopState.Track)
                                            return theme.red2;
                                        else if (Media.loop == MprisLoopState.Playlist)
                                            return theme.blue1;
                                        else
                                            return theme.fgOff;
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
                                    color: theme.fg
                                    font.bold: true
                                    font.family: theme.defaultFont
                                    font.pixelSize: 10
                                    text: `${Media.positionString}/${Media.lengthString}`
                                }
                            }
                        }
                    }
                }
            }

            Item { // center modules
                // spacing: 12
                // //Layout.alignment: Qt.AlignCenter
                // anchors.centerIn: parent
                Layout.fillHeight: true
                anchors.centerIn: parent
                Rectangle {
                    id: workspaceRoot
                    property int pillInset: 4
                    color: theme.bg
                    implicitHeight: workspacesRow.implicitHeight + pillInset
                    implicitWidth: workspacesRow.implicitWidth + pillInset
                    radius: implicitHeight / 2
                    anchors.centerIn: parent
                    RowLayout {
                        id: workspacesRow
                        anchors.centerIn: parent
                        spacing: 5
                        Repeater {
                            // Filtriamo la lista dei workspace di Hyprland
                            model: {
                                let alwaysShown = 5;
                                let ids = [];
                                for (let i = 1; i <= alwaysShown; i++) {
                                    ids.push(i);
                                }
                                // let ids = [1, 2, 3, 4, 5];
                                for (let i = 0; i < Hyprland.workspaces.values.length; i++) {
                                    let ws = Hyprland.workspaces.values[i];
                                    if (ws.id > alwaysShown)
                                        ids.push(ws.id);
                                }
                                return ids.sort((a, b) => a - b);
                            }

                            delegate: Rectangle {
                                function getWorkspaceObject(id) {
                                    for (let i = 0; i < Hyprland.workspaces.values.length; i++) {
                                        let ws = Hyprland.workspaces.values[i];
                                        if (ws.id === id)
                                            return ws;
                                    }
                                    return null;
                                }

                                readonly property var activeWs: getWorkspaceObject(modelData)

                                implicitHeight: theme.barHeigth / 2
                                implicitWidth: activeWs?.focused ? implicitHeight * 2.5 : implicitHeight
                                radius: implicitHeight / 2

                                Behavior on implicitWidth {
                                    NumberAnimation {
                                        duration: 100
                                        easing.type: Easing.OutCubic
                                    }
                                }

                                color: {
                                    if (activeWs) {
                                        if (activeWs.focused)
                                            return theme.red1;
                                        else if (activeWs.urgent)
                                            return theme.green2;
                                        else if (activeWs.toplevels.values.length > 0)
                                            return theme.magenta2;
                                    } else
                                        return theme.bg1;
                                }

                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                        easing.type: Easing.OutCubic
                                    }
                                }

                                Text {
                                    text: modelData
                                    anchors.centerIn: parent
                                    color: activeWs?.urgent ? theme.fg4 : theme.fg
                                    font.bold: true
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 200
                                            easing.type: Easing.OutCubic
                                        }
                                    }
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Hyprland.usingLua ? Hyprland.dispatch(`hl.dsp.focus({ workspace = ${modelData} })`) : Hyprland.dispatch("workspace " + modelData)
                                }
                            }
                        }
                    }
                }
            }

            RowLayout { //destra
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: root.interModuleSpacing

                Rectangle { // battery
                    visible: Battery.present
                    implicitHeight: parent.implicitHeight
                    implicitWidth: implicitHeight * 2
                    radius: implicitHeight / 2
                    color: theme.bg
                    Text{
                        text: {
                            if(Battery.percentage > 80)
                                return ""
                            else if(Battery.percentage > 60)
                                return ""
                            else if(Battery.percentage > 40)
                                return ""
                            else if(Battery.percentage > 20)
                                return ""
                            else if(Battery.percentage > 0)
                                return ""
                        }
                        color: theme.fg
                        font.family: theme.defaultFont
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: parent.radius / 2
                    }
                    Text {
                        //anchors.centerIn: parent
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        text: Battery.percentage + "%"
                        color: theme.fg
                        font.family: theme.defaultFont
                        rightPadding: parent.radius / 2
                    }
                }

                RowLayout { // volume
                    spacing: 10

                    // PwObjectTracker{
                    //     id: sinkTracker
                    //     objects: Pipewire.defaultAudioSink && Pipewire.ready ? [Pipewire.defaultAudioSink] : []
                    // }

                    // readonly property var activeSink: sinkTracker.objects.length > 0 ? sinkTracker.objects[0] : null

                    Text { //icon
                        font.family: theme.defaultFont
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
                        font.family: theme.defaultFont
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
                        property int dotSize: 12
                        value: Audio.volume
                        width: 50
                        maximum: 1
                        handleSize: dotSize
                        step: 0.05
                        handleDelegate: Rectangle {
                            color: "transparent"
                            implicitHeight: volumeSlider.dotSize
                            implicitWidth: implicitHeight
                            radius: implicitHeight / 2
                            border.color: theme.fg
                            border.width: 2
                        }
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
                    implicitHeight: parent.implicitHeight
                    implicitWidth: implicitHeight
                    radius: implicitHeight / 2
                    color: theme.bg

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
                        font.family: theme.defaultFont
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        lineHeight: 1.0
                        font.pixelSize: 19

                        text: "󰂯"
                        color: {
                            if (parent.bluetoothConnected)
                                return theme.red2; // connected
                            if (parent.bluetoothState)
                                return theme.fg; // bt on
                            return theme.fgOff; // spento
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
                        onClicked: {
                            var globalPos = parent.mapToGlobal(parent.width / 2, parent.height);
                            Global.bluetoothPopupActive = !Global.bluetoothPopupActive;
                            Global.bluetoothButtonPosition = globalPos;
                        } //bluetoothMenu.running = true// TODO bt devices menu
                    }
                }

                Rectangle { // wifi
                    implicitHeight: parent.implicitHeight
                    implicitWidth: implicitHeight
                    radius: implicitHeight / 2
                    color: theme.bg

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
                        font.family: theme.defaultFont
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
                        color: theme.fg
                    }

                    Process {
                        id: connectionApp
                        command: ["kitty", "-e", "nmtui"]
                        onExited: running = false
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            var globalPos = parent.mapToGlobal(parent.width / 2, parent.height);
                            Global.networkPopupActive = !Global.networkPopupActive;
                            //connectionApp.running = true
                            Global.networkButtonPosition = globalPos;
                        }
                    }
                }

                Column { // orologio e data
                    anchors.verticalCenter: parent.verticalCenter

                    SystemClock {
                        id: clock
                        precision: SystemClock.Seconds
                    }

                    Text { // orario
                        color: theme.fg
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: (`${clock.hours.toString().padStart(2, "0")}:${clock.minutes.toString().padStart(2, "0")}:${clock.seconds.toString().padStart(2, "0")}`)
                        font.family: theme.defaultFont
                    }

                    Text { //data
                        color: theme.fg
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: Qt.formatDate(clock.date, "ddd d/M/yyyy")
                        font.family: theme.defaultFont
                    }
                }

                Rectangle { //power button
                    implicitHeight: parent.implicitHeight
                    implicitWidth: implicitHeight
                    radius: implicitHeight / 2
                    color: theme.magenta2

                    Process {
                        id: powerOptions
                        command: ["wlogout", "-b", "6"]
                        onExited: running = false
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "⏻"
                        color: theme.fg4
                        font.pixelSize: parent.implicitHeight * 0.5
                        font.family: theme.defaultFont
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
}
