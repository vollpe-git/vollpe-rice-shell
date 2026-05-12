import qs.widgets
import qs.services
import Quickshell
import QtQuick

PopupPanel {
    visible: Global.bluetoothPopupActive
    x: Global.bluetoothButtonPosition.x
    y: Global.bluetoothButtonPosition.y
    implicitHeigth: 30
    implicitWidth: 30
}
