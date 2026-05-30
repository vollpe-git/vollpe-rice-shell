import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth
import "../services"
import "../widgets"

PopupPanel {
    id: btRoot
    x: Global.bluetoothButtonPosition.x - implicitWidth / 2// + theme.leftBarWidth
    y: Global.bluetoothButtonPosition.y
    implicitWidth: 200
    readonly property real minHeight: 100
    readonly property real maxHeight: 400
    bindProperty: "bluetoothPopupActive"

    implicitHeight: Math.max(minHeight, Math.min(maxHeight, mainColumn.height))

    // visible: Global.bluetoothPopupActive
    color: "transparent"
    Rectangle {
        anchors.fill: parent
        color: theme.bg2
        bottomLeftRadius: 25
        bottomRightRadius: bottomLeftRadius
        Behavior on height {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
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
                color: theme.fg
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
                        spacing: 0
                        Slider {
                            id: batteryBar
                            // height: deviceName.height + 4
                            width: parent.width
                            accentColor: theme.bg//modelData.connected ? theme.fg2 : theme.red1
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
                                color: modelData.connected ? theme.fg : theme.fgOff
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
                                color: theme.fg
                                Layout.fillWidth: true
                                rightPadding: parent.barThickness / 2
                                anchors.verticalCenter: parent.verticalCenter
                                horizontalAlignment: Text.AlignRight
                                anchors.left: parent.left
                                anchors.right: parent.right
                            }
                        }
                        RowLayout {
                            // Layout.fillWidth: true
                            // QUESTO
                            anchors.horizontalCenter: batteryBar.horizontalCenter
                            width: batteryBar.width - batteryBar.handleSize
                            // anchors.leftMargin: batteryBar.handleSize / 2
                            // anchors.rightMargin: anchors.leftMargin
                            height: delegateRoot.expanded ? 15 : 0
                            spacing: 5
                            Behavior on height {
                                NumberAnimation {
                                    duration: 50
                                    easing.type: Easing.OutCubic
                                }
                            }

                            // : batteryBar.horizontalCenter
                            Rectangle {
                                id: connectButton
                                implicitWidth: (parent.width * 0.80)// - (parent.spacing / 2)
                                implicitHeight: parent.height
                                // radius: 10
                                bottomLeftRadius: height / 2
                                bottomRightRadius: bottomLeftRadius
                                color: modelData.state == BluetoothDeviceState.Connecting || modelData.state == BluetoothDeviceState.Disconnecting ? theme.yellow1 : (modelData.connected ? theme.red1 : theme.blue1)
                                Text {
                                    text: {
                                        switch (modelData.state) {
                                        case BluetoothDeviceState.Connected:
                                            return "disconnect";
                                        case BluetoothDeviceState.Disconnected:
                                            return "connect";
                                        case BluetoothDeviceState.Connecting:
                                            return "connecting...";
                                        case BluetoothDeviceState.Disconnecting:
                                            return "disconnecting...";
                                        }
                                    }
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.family: theme.defaultFont
                                    color: theme.fg4
                                    font.pixelSize: parent.height - 4
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: modelData.state == BluetoothDeviceState.Connecting || modelData.state == BluetoothDeviceState.Disconnecting ? Qt.ForbiddenCursor : Qt.PointingHandCursor
                                    onClicked: {
                                        if (!(modelData.state == BluetoothDeviceState.Connecting || modelData.state == BluetoothDeviceState.Disconnecting))
                                            (modelData.connected ? modelData.disconnect() : modelData.connect());
                                    }
                                }
                            }
                            Rectangle {
                                id: forgetButton
                                // implicitWidth: (parent.width * 0.20) - (parent.spacing / 2)
                                Layout.fillWidth: true
                                implicitHeight: parent.height
                                bottomLeftRadius: implicitHeight / 2
                                bottomRightRadius: bottomLeftRadius
                                // color: "#ff0000"
                                color: theme.red1
                                Text {
                                    text: ""
                                    font.letterSpacing: 2.0
                                    anchors.fill: parent
                                    // horizontalAlignment: Text.AlignHCenter
                                    // verticalAlignment: Text.AlignVCenter
                                    // anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: theme.defaultFont
                                    font.pixelSize: parent.height - 4
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
