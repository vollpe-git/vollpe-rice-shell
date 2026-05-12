import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.services

PanelWindow {
    // anchors.top: true
    // anchors.left: true

    // width: mainLayout.implicitWidth + 20 // 20px di "padding"
    // height: mainLayout.implicitHeight + 20

    id: flRoot
    exclusionMode: ExclusionMode.Ignore
    property bool active: false
    property int buttonDimension: 40
    property int buttonSpacing: 10
    property int buttonColumns: 3
    property int buttonRows: 2
    property int topDistance: 0
    property point buttonPosition: Global.fastLauncherButtonPosition
    // x: buttonPosition.x
    anchors.top: true
    anchors.left: true
    margins.left: Global.fastLauncherButtonPosition.x - (implicitWidth / 2)
    margins.top: Global.fastLauncherButtonPosition.y + topDistance + 40
    visible: active
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
        radius: height / 4
        color: '#30ffffff'
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
                appName: "gedit"
            }
            // ---second line---
            AppButton {
                icon: ""
                appName: "kitty"
            }
            AppButton {
                icon: ""
                appName: "dolphin"
            }
            AppButton {
                icon: ""
                appName: "code"
            }
        }
    }
    component AppButton: Rectangle {
        property var icon: ""
        property var appName: ""
        Layout.alignment: Qt.AlignCenter
        // Layout.fillWidth: true
        // Layout.fillHeight: true
        height: 40
        width: height
        radius: height / 2
        Text {
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            color: "#000000"
            font.pixelSize: 30
            text: parent.icon
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
