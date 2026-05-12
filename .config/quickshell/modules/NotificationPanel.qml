import QtQuick
import QtQuick.Layouts
import Quickshell
import "../services"
import "../widgets"

PanelWindow {
    id: root
    anchors {
        // right: true
        // left: true
        top: true
        // bottom: true
    }
    // color: "#01000000"
    implicitHeight: root.screen.height * 0.85
    implicitWidth: root.screen.width / 3
    margins.top: Global.notificationPanelActive ? 0 : -height
    Behavior on margins.top {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    // focusable: false
    focusable: Global.notificationPanelActive
    // visible: Global.notificationPanelActive
    // visible: true
    Rectangle {
        id: notificationCenterManager
        anchors.horizontalCenter: parent.horizontalCenter

        // Calcolo della posizione:
        // Se attivo -> margine 0 (attaccato al top)
        // Se spento -> margine negativo pari alla sua altezza (nascosto sopra)
        anchors.top: parent.top
        anchors.fill: parent

        color: "white"
        bottomRightRadius: width / 10
        bottomLeftRadius: bottomRightRadius
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true
            onExited: {
                if (!notificationsView.focusedTextArea)
                    Global.notificationPanelActive = false;
            }
        }
        ColumnLayout {
            id: mainColumn
            anchors.fill: parent
            RowLayout { // tabs
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: mainColumn.width / 4
                Rectangle {
                    implicitHeight: 30
                    Layout.preferredWidth: mainColumn.width / 4
                    color: "black"
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: Global.notificationPanelTab = 1
                    }
                }
                Rectangle {
                    implicitHeight: 30
                    Layout.preferredWidth: mainColumn.width / 4
                    color: "black"
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: Global.notificationPanelTab = 2
                    }
                }
            }
            StackLayout {
                id: tabStackLayout
                // anchors.fill: parent
                Layout.fillHeight: true
                Layout.fillWidth: true
                NotificationsView {
                    id: notificationsView
                    visible: Global.notificationPanelTab == 1
                }
            }
        }
    }
}
