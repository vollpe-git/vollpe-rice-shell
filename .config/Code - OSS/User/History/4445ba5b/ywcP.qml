import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

PanelWindow{
    property bool active: false
    property int buttonDimension: 40
    property int buttonSpacing: 10
    property int buttonColumns: 3
    property int buttonRows: 2
    visible: active
    implicitWidth:  (buttonDimension*buttonColumns)+(buttonSpacing*(buttonColumns+2))
    implicitHeight: buttonDimension*buttonRows+buttonSpacing*(buttonRows+2)
    color: "transparent"
    // anchors.top: true
    // anchors.left: true

    // width: mainLayout.implicitWidth + 20 // 20px di "padding"
    // height: mainLayout.implicitHeight + 20

    id: flRoot
    // width: contentItem.implicitWidth + leftPadding + rightPadding
    // height: contentItem.implicitHeight + topPadding + bottomPadding
    // padding: 10 
    /* 
    spotify,    firefox󰖟,    gedit󰏪
    terminal,   dolphin,    code
    */
    mask: Region {
        item: background // La maschera seguirà la forma di questo oggetto
    }
    Rectangle{
        id: background
        anchors.fill: parent
        radius: height/4
        color: '#30ffffff'
        GridLayout{
            // Layout.fillWidth: true
            // Layout.fillHeight: true
            // columnSpacing: buttonSpacing
            // rowSpacing: buttonSpacing
            anchors.fill: parent
            anchors.leftMargin: flRoot.buttonSpacing
            anchors.rightMargin: flRoot.buttonSpacing
            anchors.topMargin: flRoot.buttonSpacing
            anchors.bottomMargin: flRoot.buttonSpacing
            id: mainLayout
            columns: 3
            component AppButton: Rectangle{
                property var icon: ""
                property var appName: ""
                Layout.alignment: Qt.AlignCenter
                // Layout.fillWidth: true
                // Layout.fillHeight: true
                height: 40
                width: height
                radius: height/2
                Text{
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    color: "#000000";
                    font.pixelSize: 30
                    text: parent.icon 
                }

                MouseArea{
                    anchors.fill: parent;
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.Runtime.execute(["sh", "-c", appName]);
                } 
            }
            AppButton{ 
                icon: ""
                appName: "spotify"
            }
            AppButton{ 
                icon: "󰖟"
                appName: "firefox"
            }
            AppButton{ 
                icon: "󰏪"
                appName: "gedit"
            }
            // ---second line---
            AppButton{ 
                icon: ""
                appName: "kitty"
            }
            AppButton{ 
                icon: ""
                appName: "dolphin"
            }
            AppButton{ 
                icon: ""
                appName: "code"
            }
        }
    }
}