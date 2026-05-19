import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property var model: []
    property string label: "Menu"
    property bool isOpen: false
    property bool noClose: false
    property string textRole: ""

    property color buttonColor: "#000000"
    property color dropdownColor: buttonColor
    property color hoverColor: "#555555"
    property color textColor: "#ffffff"
    property color textColor2: textColor
    property color dropdownBorderColor: "#aaaaaa"

    property string font: "JetBrainsMono Nerd Font"

    property int dropdownBorderWidth: 2
    property int dropdownWidth: 200

    // --- SEGNALE ---
    // Definiamo il segnale che verrà "ascoltato" dall'esterno
    signal itemSelected(var data)

    implicitWidth: 120
    implicitHeight: 35
    z: isOpen ? 999 : 0

    focus: true
    onIsOpenChanged: if (isOpen)
        root.forceActiveFocus()
    onActiveFocusChanged: if (!activeFocus && isOpen)
        isOpen = false

    // --- IL PULSANTE ---
    Rectangle {
        id: button
        anchors.fill: parent
        color: root.buttonColor
        radius: height / 2
        Text {
            // anchors.centerIn: parent
            anchors.leftMargin: parent.height / 4
            anchors.rightMargin: parent.height / 4
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: dropDownIcon.left
            // anchors.fill: parent
            text: root.label
            color: root.textColor
            elide: Text.ElideRight
            font.family: root.font
        }
        MouseArea {
            anchors.fill: parent
            onClicked: root.isOpen = !root.isOpen
        }
        Text {
            id: dropDownIcon
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: parent.height / 4
            text: "󰅃"
            font.family: root.font
            rotation: root.isOpen ? 180 : 0
            color: root.textColor2
            Behavior on rotation {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.Linear
                }
            }
        }
    }

    // --- IL MENU A TENDINA ---
    Rectangle {
        id: dropdownBody
        // visible: root.isOpen
        visible: height != 0
        y: root.height + 4
        anchors.horizontalCenter: parent.horizontalCenter
        x: 0
        width: root.dropdownWidth
        height: root.isOpen ? Math.min(column.implicitHeight + flickable.anchors.margins * 2, 300) : 0
        Behavior on height {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }
        color: root.dropdownColor
        border.color: root.dropdownBorderColor
        border.width: root.dropdownBorderWidth
        radius: button.radius + flickable.anchors.margins

        Flickable {
            id: flickable
            anchors.fill: parent
            anchors.margins: 5
            contentHeight: column.implicitHeight
            clip: true

            Column {
                id: column
                width: parent.width
                spacing: 2

                Repeater {
                    model: root.model
                    delegate: Rectangle {
                        width: parent.width
                        height: button.height
                        radius: height / 2
                        color: itemMouseArea.containsMouse ? root.hoverColor : "transparent"
                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                                easing.type: Easing.InCubic
                            }
                        }

                        Text {
                            anchors.fill: parent
                            // anchors.margins: 5
                            anchors.leftMargin: parent.radius / 2
                            anchors.rightMargin: anchors.leftMargin
                            verticalAlignment: Text.AlignVCenter
                            color: root.textColor
                            font.family: root.font
                            elide: Text.ElideRight
                            text: {
                                if (modelData === undefined || modelData === null)
                                    return "";
                                if (root.textRole !== "" && modelData[root.textRole] !== undefined) {
                                    return modelData[root.textRole];
                                }
                                return modelData.toString();
                            }
                        }

                        MouseArea {
                            id: itemMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            propagateComposedEvents: true

                            onEntered: root.noClose = true
                            onExited: root.noClose = false

                            onClicked: mouse => {
                                // 1. Inviamo il segnale all'esterno passando modelData
                                root.itemSelected(modelData);

                                // 2. Chiudiamo il menu
                                root.isOpen = false;

                                // 3. Gestiamo l'evento mouse
                                mouse.accepted = true;
                            }
                        }
                    }
                }
            }
        }
    }
}
