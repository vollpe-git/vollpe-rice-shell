import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import "../services"
import "../widgets"

Item {
    id: root
    property bool focusedTextArea: false
    property int topMargin: 20
    anchors.fill: parent
    anchors.bottomMargin: 10
    anchors.topMargin: topMargin
    anchors.leftMargin: 10
    anchors.rightMargin: anchors.leftMargin

    // Array dove salviamo i modelli delle notifiche da eliminare al restore del pannello
    property var notificationsToEliminate: []
    Connections {
        target: Global

        function onNotificationPanelActiveChanged() {
            if (!Global.notificationPanelActive) {
                // Il tuo ciclo di pulizia
                for (let i = 0; i < root.notificationsToEliminate.length; i++) {
                    if (root.notificationsToEliminate[i]) {
                        root.notificationsToEliminate[i].dismiss();
                    }
                }
                root.notificationsToEliminate = []; // Svuota l'array
            }
        }
    }

    // Ascolto la chiusura del pannello per purgare il backend
    Connections {
        target: Global
        function onNotificationPanelActiveChanged() {
            if (!Global.notificationPanelActive) {
                for (let i = 0; i < root.notificationsToEliminate.length; i++) {
                    if (root.notificationsToEliminate[i]) {
                        root.notificationsToEliminate[i].dismiss();
                    }
                }
                root.notificationsToEliminate = []; // Svuota l'array
            }
        }
    }

    Text {
        visible: Notifications.numberOfNotifications == 0
        text: "No Notifications To View"
        anchors.centerIn: parent
        font.family: theme.defaultFont
        font.pixelSize: 30
        color: theme.fg
    }

    ListView {
        id: notificationsListView
        anchors.fill: parent
        model: Notifications.notifications.values
        spacing: 0
        cacheBuffer: 0

        delegate: Item {
            id: delegateContainer
            implicitWidth: parent.width

            // Se dismessa, l'altezza collassa a 0 portandosi dietro lo spazio fantasma sotto
            implicitHeight: isDismissed ? 0 : (delegateRoot.implicitHeight + 30)

            property bool isDismissed: false

            Behavior on implicitHeight {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }

            Rectangle {
                id: delegateRoot
                color: theme.bg
                radius: implicitHeight / 2

                // FIX FONDAMENTALE: Via le ancore combinate che bloccavano lo slide!
                anchors.top: parent.top
                width: parent.width // Mantiene la pillola responsive senza usare anchors.right

                implicitHeight: mainLayout.implicitHeight + 30

                property bool inlineResponseActive: false
                clip: true

                // Opacità legata al container per svanire durante il collasso
                opacity: delegateContainer.isDismissed ? 0 : 1

                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }
                }

                SequentialAnimation {
                    id: eliminateNotification

                    NumberAnimation {
                        target: delegateRoot
                        property: "x"
                        from: 0
                        to: delegateRoot.width + 100
                        duration: 200
                        easing.type: Easing.InQuad
                    }
                    onStopped: {
                        // Pushiamo il modello corrente nell'array globale di eliminazione
                        let tempArray = root.notificationsToEliminate;
                        tempArray.push(modelData);
                        root.notificationsToEliminate = tempArray;

                        // Avviamo il collasso dell'altezza dello slot
                        delegateContainer.isDismissed = true;
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: !delegateContainer.isDismissed
                    onClicked: eliminateNotification.start()
                }

                // Struttura interna invariata
                RowLayout {
                    id: mainLayout
                    anchors.fill: parent

                    Text {
                        id: appIcon
                        text: IconMapper.getIcon(modelData.appName, "")
                        Layout.alignment: Qt.AlignVCenter
                        font.family: theme.defaultFont
                        font.pixelSize: 20
                        leftPadding: 25
                        rightPadding: leftPadding
                        color: theme.fg
                    }

                    ColumnLayout {
                        id: textAndButtonsColumn
                        Layout.fillWidth: true
                        spacing: 4
                        Layout.rightMargin: appIcon.width

                        Text {
                            text: modelData.appName
                            font.bold: true
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            font.family: theme.defaultFont
                            color: theme.fg
                            font.pixelSize: 14
                        }

                        Text {
                            text: modelData.body.replace(/<\/?[^>]+(>|$)/g, "")
                            elide: Text.ElideRight
                            textFormat: Text.PlainText
                            wrapMode: Text.WrapAnywhere
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            font.family: theme.defaultFont
                            color: theme.fg
                        }

                        RowLayout {
                            id: buttonRow
                            Layout.fillWidth: true
                            Layout.topMargin: 4
                            Layout.preferredHeight: (delegateRoot.inlineResponseActive || (modelData.hasInlineReply && !delegateRoot.inlineResponseActive)) ? 25 : 0
                            spacing: delegateRoot.inlineResponseActive ? 10 : 0
                            clip: true
                            visible: modelData.hasInlineReply && Layout.preferredHeight > 0

                            Behavior on Layout.preferredHeight {
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            TextArea {
                                id: responseInput
                                Layout.preferredWidth: delegateRoot.inlineResponseActive ? (textAndButtonsColumn.width - 100 - buttonRow.Layout.rightMargin - (buttonRow.spacing * 2)) : 0
                                implicitHeight: parent.height
                                padding: 3
                                leftPadding: 10
                                rightPadding: 10
                                font.family: theme.defaultFont
                                color: theme.fg

                                background: Rectangle {
                                    color: theme.bg1
                                    radius: height / 2
                                }

                                hoverEnabled: true
                                onHoveredChanged: root.focusedTextArea = hovered

                                Behavior on Layout.preferredWidth {
                                    NumberAnimation {
                                        duration: 100
                                        easing.type: Easing.Linear
                                    }
                                }
                            }

                            Rectangle { // Tasto Nero (Invia)
                                id: sendResponse
                                color: theme.blue1
                                implicitHeight: parent.height
                                radius: implicitHeight / 2
                                Layout.preferredWidth: delegateRoot.inlineResponseActive ? 50 : 0
                                clip: true

                                Behavior on Layout.preferredWidth {
                                    NumberAnimation {
                                        duration: 100
                                        easing.type: Easing.Linear
                                    }
                                }

                                Text {
                                    text: "➔"
                                    color: theme.fg4
                                    anchors.centerIn: parent
                                    font.family: theme.defaultFont
                                    font.pixelSize: 25
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: eliminateNotificationReply.start()
                                }

                                SequentialAnimation {
                                    id: eliminateNotificationReply

                                    NumberAnimation {
                                        target: delegateRoot
                                        property: "x"
                                        from: 0
                                        to: delegateRoot.width + 100
                                        duration: 300
                                        easing.type: Easing.InQuad
                                    }
                                    NumberAnimation {
                                        target: delegateRoot
                                        property: "height"
                                        to: 0
                                        duration: 100
                                        easing.type: Easing.Linear
                                    }
                                    onStopped: {
                                        modelData.sendInlineReply(responseInput.text);
                                        delegateContainer.isDismissed = true;
                                    }
                                }
                            }

                            Rectangle { // Tasto Rosso (Reply / Chiudi)
                                id: openCloseResponse
                                color: theme.red1
                                implicitHeight: parent.height
                                radius: implicitHeight / 2
                                Layout.preferredWidth: delegateRoot.inlineResponseActive ? 50 : (textAndButtonsColumn.width - buttonRow.Layout.rightMargin)
                                clip: true

                                Behavior on Layout.preferredWidth {
                                    NumberAnimation {
                                        duration: 100
                                        easing.type: Easing.Linear
                                    }
                                }

                                Text {
                                    text: delegateRoot.inlineResponseActive ? "" : "Reply"
                                    color: theme.fg4
                                    font.family: theme.defaultFont
                                    font.pixelSize: delegateRoot.inlineResponseActive ? 20 : 15
                                    anchors.centerIn: parent
                                    font.bold: true
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: delegateRoot.inlineResponseActive = !delegateRoot.inlineResponseActive
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 30
        anchors.rightMargin: anchors.leftMargin
        anchors.bottomMargin: 10

        height: 30
        radius: height / 2
        color: theme.red1
        Text {
            text: " CLEAR ALL "
            font.family: theme.defaultFont
            font.pixelSize: 20
            color: theme.fg4
            anchors.centerIn: parent
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                let activeNotifications = Notifications.notifications.values;
                for (let i = activeNotifications.length - 1; i >= 0; i--) {
                    if (activeNotifications[i]) {
                        activeNotifications[i].dismiss();
                    }
                }
            }
        }
    }
}
