import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "../services"
import "../widgets"

Item {
    anchors.margins: 5
    anchors.fill: parent
    RowLayout {
        // Layout.fillWidth: true
        // Layout.fillHeight: true
        anchors.fill: parent
        TextArea {
            id: textArea
            Layout.fillHeight: true
            Layout.fillWidth: true
            wrapMode: TextEdit.Wrap
            textFormat: TextEdit.AutoText
            font.family: theme.defaultFont
            font.pixelSize: 15
            background: Rectangle {
                color: theme.bg1 // Il tuo colore di sfondo (es. "#1e1e2e" o "black")
                radius: 10       // Se vuoi i bordi arrotondati
                border.color: textArea.activeFocus ? theme.bg : theme.bg1 // Bordo dinamico se attiva
                border.width: 1
            }
            color: theme.fg
        }
        ColumnLayout {
            spacing: 10
            Rectangle {
                implicitWidth: 20
                implicitHeight: implicitWidth
                color: theme.red1
                // Layout.fillHeight: true
                radius: implicitWidth / 2
                // border.width: 1
                // border.color: theme.red1
                // border.pixelAligned: true
                Text {
                    text: ""
                    font.family: theme.defaultFont
                    anchors.centerIn: parent
                    color: theme.fg4
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Global.notesActive = false
                }
            }
            MyButton {
                //clear button
                icon: ""
                color: theme.blue1
                // textColor:
                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    onClicked: {
                        textArea.selectAll();
                        textArea.copy();
                        textArea.deselect();
                    }
                }
            }
            MyButton {
                // copy button
                icon: ""
                color: theme.red1
                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    onClicked: textArea.clear()
                }
            }
            MyButton {
                // save file button
                icon: ""
                color: theme.magenta2
                // textColor: theme.fg
                SystemClock {
                    id: clock
                    precision: SystemClock.Minutes
                }
                Process {
                    id: saveFile
                    command: ["sh", "-c", "echo '" + textArea.text + "' > ~/Documents/Notes/" + Qt.formatDate(clock.date, "dd-MM-yyyy") + "@" + Qt.formatDateTime(clock.date, "hh-mm") + ".rtf"]
                    onExited: running = false
                }
                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    onClicked: {
                        saveFile.running = true;
                    }
                }
            }
        }
    }
    component MyButton: Rectangle {
        implicitWidth: 20
        // color: theme.bg1
        Layout.fillHeight: true
        radius: implicitWidth / 2
        property string icon: "?"
        property color textColor: theme.fg4
        Text {
            font.pixelSize: 14
            font.bold: true
            text: parent.icon
            font.family: theme.defaultFont
            anchors.centerIn: parent
            color: parent.textColor
        }
    }
}
