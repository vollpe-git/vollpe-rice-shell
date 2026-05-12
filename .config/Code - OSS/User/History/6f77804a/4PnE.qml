import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.services

PanelWindow {
    id: nwroot
    implicitWidth: Screen.width / 3
    implicitHeight: Screen.height - (Screen.height / 5)
    visible: Global.networkPopupActive
    anchors {
        right: true
        bottom: true
    }
    ListView {}
}
