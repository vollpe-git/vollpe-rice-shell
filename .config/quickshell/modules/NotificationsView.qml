import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import "../services"
import "../widgets"

Item {
    id: root
    property bool focusedTextArea: false
    anchors.fill: parent
    anchors.bottomMargin: 30
    Text {
        visible: Notifications.numberOfNotifications == 0
        text: "No Notifications To View"
        anchors.centerIn: parent
    }
    ListView {
        anchors.fill: parent
        model: Notifications.notifications.values
        spacing: 40
        delegate: Rectangle {
            id: delegateRoot
            color: "transparent"
            implicitWidth: parent.width
            implicitHeight: mainLayout.implicitHeight
            property bool inlineResponseActive: false
            MouseArea {
                anchors.fill: parent
                onClicked: modelData.dismiss()
            }
            RowLayout {
                id: mainLayout
                anchors.margins: 15
                spacing: 15
                anchors.left: parent.left
                anchors.right: parent.right
                // Layout.fillHeight: true
                // Layout.fillWidth: true
                Text {
                    text: modelData.appIcon || ""
                    Layout.alignment: Qt.AlignVCenter
                }
                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Text {
                        text: modelData.appName
                        font.bold: true
                    }
                    Text {
                        text: modelData.body
                        elide: Text.ElideRight
                    }
                    RowLayout {
                        // visible: modelData.hasInlineReply
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        TextArea {
                            id: responseInput
                            visible: delegateRoot.inlineResponseActive
                            Layout.fillWidth: true
                            implicitHeight: 20
                            padding: 0
                            // onFocusChanged: root.focusedTextArea = focus
                            hoverEnabled: true
                            onHoveredChanged: root.focusedTextArea = hovered
                        }
                        Rectangle { // send inline response
                            // Layout.fillWidth: !delegateRoot.inlineResponseActive
                            visible: delegateRoot.inlineResponseActive
                            implicitWidth: parent.width * 0.12
                            implicitHeight: responseInput.height
                            color: "black"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: modelData.sendInlineReply(responseInput.text)
                            }
                        }
                        Rectangle { // open/close inline response button
                            // visible: !delegateRoot.inlineResponseActive
                            visible: modelData.hasInlineReply
                            Layout.fillWidth: !delegateRoot.inlineResponseActive
                            implicitWidth: parent.width * 0.12
                            implicitHeight: responseInput.height
                            color: "#ff0000"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: delegateRoot.inlineResponseActive = !delegateRoot.inlineResponseActive
                            }
                        }
                    }
                }
            }
        }
    }
}
