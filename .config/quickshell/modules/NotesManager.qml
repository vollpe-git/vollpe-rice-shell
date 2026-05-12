import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../services"
import "../widgets"

PanelWindow {
    id: root
    // visible: Global.notesActive
    property int distance: 0
    // margins.left: distance
    // focusable: Global.notesTab == 1 && Global.notesActive
    focusable: Global.notesActive
    margins.left: Global.notesActive ? distance : -implicitWidth
    color: "transparent"

    Behavior on margins.left {
        NumberAnimation {
            duration: 100
            easing.type: Easing.OutCubic
            // onRunningChanged: {
            //     if (!running)
            //         root.visible = Global.notesActive;
            //     else
            //         root.visible = true;
            // }
        }
    }

    visible: isActive ? true : false
    Behavior on visible {
        NumberAnimation {
            duration: 250
        }
    }

    implicitHeight: screen.height / 2.5
    implicitWidth: implicitHeight
    anchors.left: true
    exclusionMode: ExclusionMode.Ignore

    Rectangle {
        anchors.fill: parent
        topRightRadius: root.distance / 2
        bottomRightRadius: topRightRadius
        // tab 1: text
        NotesText {
            anchors.fill: parent
            visible: Global.notesTab == 1
        }
        NotesDrawing {
            anchors.fill: parent
            visible: Global.notesTab == 2
        }
    }
}
