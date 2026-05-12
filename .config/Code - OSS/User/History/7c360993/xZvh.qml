import Quickshell
import Quickshell.Wayland
import QtQuickshell

PanelWindow{
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: "#ffffff"

    Text{
        anchors.centerIn: parent
        text: "my first bar"
        color: "#000000"
    }
}