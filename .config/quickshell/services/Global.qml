pragma Singleton
//qmllint disable unused-imports
import QtQuick
import Quickshell

Singleton {
    property bool fastLauncherActive: false
    property point fastLauncherButtonPosition: Qt.point(0, 0)

    property bool networkPopupActive: false
    property point networkButtonPosition: Qt.point(0, 0)

    property bool bluetoothPopupActive: false
    property point bluetoothButtonPosition: Qt.point(0, 0)

    property int notesTab: 1
    property bool notesActive: false

    property bool notificationPanelActive: false
    property int notificationPanelTab: 1
}
