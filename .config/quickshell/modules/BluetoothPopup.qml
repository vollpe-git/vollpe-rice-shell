import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "../services"
import "../widgets"

PopupPanel {
    id: btRoot
    x: Global.bluetoothButtonPosition.x - implicitWidth / 2
    y: Global.bluetoothButtonPosition.y
    implicitWidth: 200
    readonly property real minHeight: 100
    readonly property real maxHeight: 400

    implicitHeight: Math.max(minHeight, Math.min(maxHeight, mainColumn.height))

    visible: Global.bluetoothPopupActive
    color: "transparent"
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
                text: "Bluetooth"
            }
            ListView {
                id: listViewRoot
                width: parent.width
                height: Math.min(contentHeight, btRoot.maxHeight)
                // Layout.fillHeight: true
                model: Bluetooth.devices.values
                spacing: 10
                contentHeight: contentItem.childrenRect.height + title.height + listViewPadding.height
                delegate: Rectangle {
                    id: delegateRoot
                    height: mainDelegateColumn.implicitHeight
                    width: listViewRoot.width
                    color: "transparent"
                    property bool expanded: false
                    Column {
                        // anchors.fill: parent
                        id: mainDelegateColumn
                        width: parent.width
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        spacing: 2
                        Slider {
                            id: batteryBar
                            // height: deviceName.height + 4
                            width: parent.width
                            accentColor: "#999999"
                            handleSize: deviceName.height + 4
                            barThickness: deviceName.height + 4
                            dotSize: 0
                            dotColor: "transparent"
                            cutBar: false
                            minimum: 0
                            maximum: 1
                            step: 0
                            value: modelData.batteryAvailable ? battery : 1
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: delegateRoot.expanded = !delegateRoot.expanded
                            }
                            Text {
                                id: deviceName
                                text: modelData.name || "Unknown Device"
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                font.bold: modelData.connected
                                color: "#000000"
                                Layout.fillWidth: true
                                leftPadding: parent.barThickness / 2
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.right: parent.right
                                // width: parent.width * 0.75
                                elide: Text.ElideRight // Taglia il testo se troppo lungo
                            }
                            Text {
                                id: deviceBattery
                                text: (modelData.batteryAvailable ? Math.round(modelData.battery * 100) + "%" : (modelData.connected ? "??%" : ""))
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                font.bold: modelData.connected
                                color: "#000000"
                                Layout.fillWidth: true
                                rightPadding: parent.barThickness / 2
                                anchors.verticalCenter: parent.verticalCenter
                                horizontalAlignment: Text.AlignRight
                                anchors.left: parent.left
                                anchors.right: parent.right
                            }
                        }
                        Row {
                            // Layout.fillWidth: true
                            width: batteryBar.width
                            height: delegateRoot.expanded ? 20 : 0
                            spacing: 10
                            Rectangle {
                                id: connectButton
                                implicitWidth: (parent.width * 0.90) - (parent.spacing / 2)
                                implicitHeight: parent.height
                                radius: 10
                                color: "#00ff00"
                                Text {
                                    text: modelData.connected ? "disconnect" : "connect"
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: modelData.connected ? modelData.disconnect() : modelData.connect()
                                }
                            }
                            Rectangle {
                                id: forgetButton
                                implicitWidth: (parent.width * 0.10) - (parent.spacing / 2)
                                implicitHeight: parent.height
                                radius: 10
                                // color: "#ff0000"
                                color: "transparent"
                                Text {
                                    text: ""
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: modelData.forget()
                                }
                            }
                        }
                        // Rectangle {
                        //     id: connectButton
                        //     implicitWidth: (parent.width * 0.25) - 5
                        //     implicitHeight: parent.height
                        //     radius: 10
                        //     color: "#ff0000"
                        // }
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
