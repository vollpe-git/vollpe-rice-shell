import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.services
import qs.widgets

PopupPanel {
    // anchors.top: true
    // anchors.left: true

    // width: mainLayout.implicitWidth + 20 // 20px di "padding"
    // height: mainLayout.implicitHeight + 20

    id: flRoot
    // exclusionMode: ExclusionMode.Ignore
    property int buttonDimension: 40
    property int buttonSpacing: 10
    property int buttonColumns: 3
    property int buttonRows: 2
    property int topDistance: 0
    property point buttonPosition: Global.fastLauncherButtonPosition
    // x: buttonPosition.x
    // anchors.top: true
    // anchors.left: true
    x: Global.fastLauncherButtonPosition.x - (implicitWidth / 2)// + theme.leftBarWidth
    y: Global.fastLauncherButtonPosition.y + topDistance + theme.barPadding / 2
    // visible: Global.fastLauncherActive
    // onVisibleChanged: {
    //     if (visible)
    //         active = visible;
    // }
    // onActiveChanged: {
    //     Global.fastLauncherActive = active;
    // }
    bindProperty: "fastLauncherActive"
    implicitWidth: (buttonDimension * buttonColumns) + (buttonSpacing * (buttonColumns + 2))
    implicitHeight: buttonDimension * buttonRows + buttonSpacing * (buttonRows + 2)
    color: "transparent"
    // width: contentItem.implicitWidth + leftPadding + rightPadding
    // height: contentItem.implicitHeight + topPadding + bottomPadding
    // padding: 10
    /*
    spotify,    firefox󰖟,    gedit󰏪
    terminal,   dolphin,    code
    */
    mask: Region {
        item: background // La maschera seguirà la forma di questo oggetto
    }
    Rectangle {
        id: background
        anchors.fill: parent
        // radius: height / 4
        bottomLeftRadius: 25
        bottomRightRadius: bottomLeftRadius
        color: theme.bg2
        GridLayout {
            id: mainLayout
            // Layout.fillWidth: true
            // Layout.fillHeight: true
            // columnSpacing: buttonSpacing
            // rowSpacing: buttonSpacing
            anchors.fill: parent
            anchors.leftMargin: flRoot.buttonSpacing
            anchors.rightMargin: flRoot.buttonSpacing
            anchors.topMargin: flRoot.buttonSpacing
            anchors.bottomMargin: flRoot.buttonSpacing
            columns: 3
            AppButton {
                icon: ""
                appName: "spotify-launcher"
            }
            AppButton {
                icon: "󰖟"
                appName: "firefox"
            }
            AppButton {
                icon: "󰏪"
                appName: "fresh"
                command: ["kitty", "-e", "fresh"]
            }
            // ---second line---
            AppButton {
                icon: ""
                appName: "kitty"
            }
            AppButton {
                icon: ""
                appName: "yazi"
                command: ["kitty", "-e", "yazi"]
            }
            AppButton {
                icon: ""
                appName: "zeditor"
            }
        }
    }
    component AppButton: Rectangle {
        property var icon: ""
        property var appName: ""
        Layout.alignment: Qt.AlignCenter
        property alias command: appCommand.command
        // Layout.fillWidth: true
        // Layout.fillHeight: true
        height: 40
        width: height
        radius: height / 2
        color: theme.bg
        Text {
            anchors.centerIn: parent
            // verticalAlignment: Text.AlignVCenter
            // horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 24
            text: parent.icon
            color: theme.fg
        }
        Process {
            id: appCommand
            // Usiamo un array di stringhe.
            // Passare per la shell è il modo più sicuro per lanciare binari.
            command: ["sh", "-c", appName]
        }

        function startApp() {
            // 1. Usiamo startDetached() così il processo continua
            // anche se Quickshell chiude questa finestra o distrugge l'oggetto.
            appCommand.startDetached();

            // 2. Chiudiamo la finestra
            flRoot.active = false;
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: startApp()
        }
    }
}
