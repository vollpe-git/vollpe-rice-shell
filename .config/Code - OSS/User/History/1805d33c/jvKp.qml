import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

PanelWindow{
    property var x: 0
    property var y: 0
    property width: 10
    property height: 10

    implicitWidth: width
    implicitHeight: height  
    anchors{
        left: true
        top: true
    }
}