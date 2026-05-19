import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.services

PanelWindow { //qmllint disable uncreatable-type
    id: root
    // property bool active: false
    property var x: 0
    property var y: 0
    // focusable: true
    exclusionMode: ExclusionMode.Ignore

    Behavior on margins.top {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    margins.top: root.bindTarget[root.bindProperty] ? y : -height
    margins.left: x
    anchors {
        left: true
        top: true
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onExited: {
            root.active = false;
        }
    }

    // onVisibleChanged: {
    //     if (visible)
    //         active = visible;
    // }

    property var bindTarget: Global
    property string bindProperty: ""

    // visible: (bindTarget && bindProperty) ? bindTarget[bindProperty] : false

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onExited: {
            if (root.bindTarget && root.bindProperty) {
                root.bindTarget[root.bindProperty] = false;
            }
        }
    }
}
