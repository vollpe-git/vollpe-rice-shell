import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

PanelWindow {
    property var x: 0
    property var y: 0
    property var popupWidth: 10
    property var popupHeight: 10

    implicitWidth: popupWidth
    implicitHeight: popupHeight
    anchors {
        left: true
        top: true
    }
}
