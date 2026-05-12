import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

PanelWindow { //qmllint disable uncreatable-type
    property var x: 0
    property var y: 0

    margins.top: y
    margins.left: x
    anchors {
        left: true
        top: true
    }
}
