import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
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
        clip: true

        color: theme.bg
        bottomRightRadius: width / 10
        bottomLeftRadius: bottomRightRadius
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true
            // preventStealing: true
            onExited: {
                console.log(`mouseX: ${mouseX}; mouseY: ${mouseY}`);
                // if (mouseX > 0 && mouseX < root.width && mouseY > 0 && mouseY < root.height) {
                //     console.log(`mouseX: ${mouseX}; mouseY: ${mouseY}`)
                //     return;
                // }
                if (!notificationsView.focusedTextArea && !multiManager.noClosing)
                    Global.notificationPanelActive = false;
            }
        }
        ColumnLayout {
            id: mainColumn
            anchors.fill: parent
            spacing: 0
            RowLayout { // tabs
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: mainColumn.width / 4
                Rectangle {
                    implicitHeight: 30
                    Layout.preferredWidth: mainColumn.width / 4
                    color: Global.notificationPanelTab == 1 ? theme.bg1 : theme.bg
                    topLeftRadius: width / 2
                    topRightRadius: topLeftRadius
                    Text {
                        anchors.centerIn: parent
                        color: theme.fg
                        font.family: theme.defaultFont
                        font.pixelSize: 14
                        font.bold: Global.notificationPanelTab == 1
                        text: "NOTIFICATIONS"
                    }
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: Global.notificationPanelTab = 1
                    }
                }
                Rectangle {
                    implicitHeight: 30
                    Layout.preferredWidth: mainColumn.width / 4
                    color: Global.notificationPanelTab == 2 ? theme.bg1 : theme.bg
                    topLeftRadius: width / 2
                    topRightRadius: topLeftRadius
                    Text {
                        anchors.centerIn: parent
                        color: theme.fg
                        font.family: theme.defaultFont
                        font.pixelSize: 14
                        font.bold: Global.notificationPanelTab == 2
                        text: "MANAGING"
                    }
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
                property int contentPadding: 10
                Layout.leftMargin: contentPadding
                Layout.rightMargin: contentPadding
                Layout.bottomMargin: contentPadding
                ClippingRectangle {
                    // anchors.fill: parent
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    color: theme.bg1
                    radius: notificationCenterManager.bottomLeftRadius - tabStackLayout.contentPadding
                    clip: true
                    NotificationsView {
                        id: notificationsView
                        topMargin: (notificationCenterManager.bottomLeftRadius - tabStackLayout.contentPadding) / 2
                        visible: Global.notificationPanelTab == 1
                    }
                    MultiManager {
                        id: multiManager
                        visible: Global.notificationPanelTab == 2
                    }
                }
            }
        }
    }
}
