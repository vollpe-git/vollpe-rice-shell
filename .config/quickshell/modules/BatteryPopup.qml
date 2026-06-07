import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.services
import qs.widgets

PopupPanel {
    x: Global.batteryButtonPosition.x - (implicitWidth / 2)// + theme.leftBarWidth
    y: Global.batteryButtonPosition.y + theme.barPadding / 2
    implicitWidth: 175
    implicitHeight: 40
    bindProperty: "batteryPopupActive"
    color: "transparent"
    Rectangle{
        anchors.fill: parent
        color: theme.bg
        radius: height/2
        Text{
            text: Battery.charging ? "time to full" : "time to empty"
            font.family: theme.defaultFont
            color: theme.fg
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: parent.radius / 2
        }
        Text{
            //text: Battery.charging ? Battery.timeToFullString() : Battery.timeToEmptyString()
            text: Battery.timeLeft
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            rightPadding: parent.radius / 2
            font.family: theme.defaultFont
            color: theme.fg
        }
    }
}