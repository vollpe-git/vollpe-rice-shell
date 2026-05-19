import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "../services"
import "../widgets"

PopupPanel {
    id: nwRoot
    x: Global.networkButtonPosition.x - implicitWidth / 2// + theme.leftBarWidth
    // y: Global.networkPopupActive ? Global.networkButtonPosition.y : -height
    y: Global.networkButtonPosition.y
    // x: 100
    // y: 100
    implicitWidth: 200
    readonly property real minHeight: 100
    readonly property real maxHeight: 800

    implicitHeight: Math.max(minHeight, Math.min(maxHeight, mainColumn.height))
    Behavior on implicitHeight {
        NumberAnimation {
            duration: 10
            easing.type: Easing.Linear
        }
    }

    bindProperty: "networkPopupActive"

    color: "transparent"
    // visible: Global.networkPopupActive
    Rectangle {
        anchors.fill: parent
        color: theme.bg2
        bottomLeftRadius: 25
        bottomRightRadius: bottomLeftRadius
        Column {
            id: mainColumn
            width: parent.width
            // anchors.fill: parent
            spacing: 10
            Text {
                id: title
                width: parent.width
                topPadding: 10
                bottomPadding: 10
                horizontalAlignment: Text.AlignHCenter
                font.family: theme.defaultFont
                color: theme.fg
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
                            color: theme.bg
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
                                    font.family: theme.defaultFont
                                    color: theme.fg
                                }

                                Text {
                                    text: modelData.type == 1 ? "WiFi" : (modelData.type == 2 ? "Wired" : "None")
                                    color: theme.fgOff
                                    font.pixelSize: 11
                                }

                                // Icona o testo per indicare l'espansione (opzionale)
                                Text {
                                    text: "󰅃"
                                    font.family: "JetBrainsMono Nerd Font"
                                    rotation: delegateDeviceRoot.expanded ? 180 : 0
                                    color: theme.fg
                                    Behavior on rotation {
                                        NumberAnimation {
                                            duration: 150
                                            easing.type: Easing.Linear
                                        }
                                    }
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
                            Behavior on height {
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.Linear
                                }
                            }
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
                                    color: theme.fg
                                    font.bold: true
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                    font.family: theme.defaultFont
                                }
                                Rectangle {
                                    Layout.alignment: Qt.AlignRight
                                    implicitHeight: nwName.implicitHeight
                                    implicitWidth: implicitHeight
                                    radius: implicitHeight / 2
                                    color: modelData.connected ? theme.blue1 : (modelData.state == 1 || modelData.state == 5 ? theme.yellow1 : theme.red1)
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
