import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.services
import qs.widgets

PopupPanel {
    id: nwroot
    x: Screen.width - implicitWidth - 40
    y: Screen.height - implicitHeigth
    implicitWidth: Screen.width / 3
    implicitHeight: Screen.height - (Screen.height / 5)
    visible: Global.networkPopupActive
    ListView {}
}
