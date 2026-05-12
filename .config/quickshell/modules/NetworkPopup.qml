import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "../services"
import "../widgets"

PopupPanel {
    id: nwRoot
    x: Global.networkButtonPosition.x - implicitWidth / 2
    y: Global.networkButtonPosition.y
    // x: 100
    // y: 100
    implicitWidth: 200
    readonly property real minHeight: 100
    readonly property real maxHeight: 800

    implicitHeight: Math.max(minHeight, Math.min(maxHeight, mainColumn.height))

    color: "transparent"
    visible: Global.networkPopupActive
    Rectangle {
        anchors.fill: parent
        color: "#ffffff"
        radius: 50
        Column {
            id: mainColumn
            width: parent.width
            // anchors.fill: parent
            spacing: 10
            Text {
                id: title
                width: parent.width
                topPadding: 25
                bottomPadding: 15
                horizontalAlignment: Text.AlignHCenter
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                text: "Networks"
            }
            ListView { // devices
                id: listViewDevices
                readonly property real minHeight: 100
                readonly property real maxHeight: 350
                width: parent.width
                height: Math.min(contentHeight, nwRoot.maxHeight)
                // Layout.fillHeight: true
                spacing: 10
                model: Network.devices.values
                // model: 3
                delegate: Item { // Il delegato radice ora è un Item neutro
                    id: delegateDeviceRoot
                    property bool expanded: false
                    // L'altezza totale è data dalla somma dei componenti interni
                    height: deviceHeader.height + (expanded ? listViewNetworks.height : 0)
                    width: listViewDevices.width

                    Column {
                        anchors.fill: parent
                        spacing: 5

                        // QUESTO è il rettangolo grigio che fa da sfondo SOLO all'header
                        Rectangle {
                            id: deviceHeader
                            width: parent.width - 30 // Sottraiamo i margini (15+15)
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: 20 // Altezza fissa o implicitHeight del RowLayout
                            color: "#CCCCCC"
                            radius: 10

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                spacing: 10

                                Text {
                                    text: modelData.name
                                    Layout.fillWidth: true
                                    font.bold: true
                                }

                                Text {
                                    text: modelData.type == 1 ? "WiFi" : (modelData.type == 2 ? "Wired" : "None")
                                    color: "#555555"
                                    font.pixelSize: 11
                                }

                                // Icona o testo per indicare l'espansione (opzionale)
                                Text {
                                    text: delegateDeviceRoot.expanded ? "󰅃" : "󰅀"
                                    font.family: "JetBrainsMono Nerd Font"
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: delegateDeviceRoot.expanded = !delegateDeviceRoot.expanded
                            }
                        }

                        // La ListView delle reti ora è FUORI dal rettangolo grigio
                        ListView {
                            id: listViewNetworks
                            width: parent.width - 70// Un po' più stretta per l'indentazione
                            anchors.horizontalCenter: parent.horizontalCenter
                            // visible: delegateDeviceRoot.expanded
                            height: delegateDeviceRoot.expanded ? contentHeight : 0
                            model: modelData.networks.values
                            // interactive: false
                            spacing: 5

                            delegate: RowLayout {
                                implicitHeight: nwName.implicitHeight
                                width: listViewNetworks.width
                                Text {
                                    id: nwName
                                    text: modelData.name
                                    font.pixelSize: 12
                                    color: "#333333"
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                                Rectangle {
                                    Layout.alignment: Qt.AlignRight
                                    implicitHeight: nwName.implicitHeight
                                    implicitWidth: implicitHeight
                                    radius: implicitHeight / 2
                                    color: modelData.connected ? "#00ff00" : (modelData.state == 1 || modelData.state == 5 ? "#ffB000" : "#ff0000")
                                    MouseArea {
                                        cursorShape: Qt.PointingHandCursor
                                        anchors.fill: parent
                                        onClicked: modelData.connected ? modelData.disconnect() : modelData.connect()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Item {
                id: listViewPadding
                width: 1
                height: 10
            }
        }
    }
}
