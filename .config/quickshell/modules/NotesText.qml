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
        }
        ColumnLayout {
            spacing: 10
            Rectangle {
                implicitWidth: 20
                implicitHeight: implicitWidth
                color: "black"
                // Layout.fillHeight: true
                radius: implicitWidth / 2
                Text {
                    text: ""
                    font.family: 'JetBrainsMono Nerd Font'
                    anchors.centerIn: parent
                    color: "#ffffff"
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
                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    onClicked: textArea.clear()
                }
            }
            MyButton {
                // save file button
                icon: ""
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
        color: "black"
        Layout.fillHeight: true
        radius: implicitWidth / 2
        property string icon: "?"
        Text {
            text: parent.icon
            font.family: 'JetBrainsMono Nerd Font'
            anchors.centerIn: parent
            color: "#ffffff"
        }
    }
}
