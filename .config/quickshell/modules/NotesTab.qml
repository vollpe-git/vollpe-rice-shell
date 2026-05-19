import QtQuick
import QtQuick.Layouts
import Quickshell
import "../services"
import "../widgets"

PanelWindow {
    id: root
    color: "transparent"
    // property int thickness: theme.leftBarWidth
    implicitWidth: theme.leftBarWidth
    implicitHeight: screen.height / 2.5
    anchors.left: true
    anchors.top: true
    anchors.bottom: true
    margins.bottom: theme.barHeigth

    Rectangle {
        implicitHeight: screen.height / 2.5
        implicitWidth: parent.width
        anchors.centerIn: parent
        // y: root.screen.height / 2 - implicitHeight / 2 + theme.barHeight
        // radius: width / 2
        topLeftRadius: width / 2
        bottomLeftRadius: topLeftRadius
        topRightRadius: Global.notesActive ? 0 : topLeftRadius
        bottomRightRadius: Global.notesActive ? 0 : topLeftRadius
        color: theme.bg

        // Usiamo un Item contenitore per gestire il padding reale
        // senza confondere il ColumnLayout
        Item {
            anchors.fill: parent
            anchors.margins: 4 // Questo crea l'effetto concentrico (spazio bianco intorno)

            ColumnLayout {
                anchors.fill: parent
                spacing: 4 // Spazio tra i due elementi interni

                Rectangle { // text tab
                    id: textRect
                    // La larghezza si adatta al contenitore con margini
                    Layout.fillWidth: true

                    // L'altezza deve sottrarre lo spacing per non sforare
                    Layout.preferredHeight: (Global.notesTab == 1 ? parent.height * 0.7 : parent.height * 0.3) - (parent.spacing / 2)

                    Layout.alignment: Qt.AlignHCenter
                    radius: width / 2
                    // color: theme.fg
                    color: Global.notesTab == 1 ? theme.fg : theme.fgOff
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.Linear
                        }
                    }

                    // Animazione fluida del cambio dimensione (opzionale ma consigliata)
                    Behavior on Layout.preferredHeight {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: {
                            Global.notesActive = Global.notesTab == 1 ? !Global.notesActive : true;
                            Global.notesTab = 1;
                        }
                    }
                }

                Rectangle { // drawing tab
                    id: drawRect
                    Layout.fillWidth: true

                    Layout.preferredHeight: (Global.notesTab == 2 ? parent.height * 0.7 : parent.height * 0.3) - (parent.spacing / 2)

                    Layout.alignment: Qt.AlignHCenter
                    radius: width / 2
                    // color: Global.notesTab == 2 ? "black" : "#bbbbbb"
                    // color: theme.bg4
                    color: Global.notesTab == 2 ? theme.fg : theme.fgOff
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.Linear
                        }
                    }

                    Behavior on Layout.preferredHeight {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: {
                            Global.notesActive = Global.notesTab == 2 ? !Global.notesActive : true;
                            Global.notesTab = 2;
                        }
                    }
                }
            }
        }
    }
}
