pragma Singleton
//qmllint disable unused-imports
import QtQuick
import Quickshell

Singleton {
    property bool fastLauncherActive: false
    property point fastLauncherButtonPosition: Qt.point(0, 0)

    property bool networkPopupActive: false
    property point networkButtonPosition: Qt.point(0, 0)
}
