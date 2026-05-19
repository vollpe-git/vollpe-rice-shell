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

    Text {
        visible: Notifications.numberOfNotifications == 0
        text: "No Notifications To View"
        anchors.centerIn: parent
        font.family: theme.defaultFont
        font.pixelSize: 30
        color: theme.fg
    }

    ListView {
        anchors.fill: parent
        model: Notifications.notifications.values
        spacing: 30

        delegate: Rectangle {
            id: delegateRoot
            color: theme.bg
            radius: implicitHeight / 2 // Pillola geometricamente perfetta sempre
            implicitWidth: parent.width

            // L'altezza totale segue il layout principale, così la pillola cresce/si stringe
            implicitHeight: mainLayout.implicitHeight + 30

            property bool inlineResponseActive: false
            clip: true

            Behavior on implicitHeight {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }

            SequentialAnimation {
                id: eliminateNotification

                NumberAnimation {
                    id: slideOutAnimation
                    target: delegateRoot
                    property: "x"
                    from: 0
                    to: delegateRoot.width + 100 // Sposta tutto il contenuto oltre il bordo destro della notifica
                    duration: 300
                    easing.type: Easing.InQuad
                    // TRIGGER FONDAMENTALE: Cancella la notifica dal backend solo quando lo slide è finito!
                    // onStopped: slideUpAnimation.start()
                }
                NumberAnimation {
                    id: slideUpAnimation
                    target: delegateRoot
                    property: "height"
                    // from: parent.height
                    to: 0
                    duration: 100
                    easing.type: Easing.Linear
                    // TRIGGER FONDAMENTALE: Cancella la notifica dal backend solo quando lo slide è finito!
                    // onStopped: modelData.dismiss()
                }
                onStopped: modelData.dismiss()
            }

            MouseArea {
                anchors.fill: parent
                // Invece di killare subito la notifica, avviamo l'animazione
                onClicked: eliminateNotification.start()
            }

            // MouseArea {
            //     anchors.fill: parent
            //     onClicked: modelData.dismiss()
            // }

            // LA TUA STRUTTURA: Icona a sinistra, colonna di contenuti a destra
            RowLayout {
                id: mainLayout
                anchors.fill: parent
                // anchors.margins: 15
                // anchors.leftMargin: 25
                // anchors.rightMargin: anchors.leftMargin
                // spacing: 15

                Text {
                    id: appIcon
                    text: IconMapper.getIcon(modelData.appName, "")
                    Layout.alignment: Qt.AlignVCenter // CENTRATA RISPETTO A TUTTA LA NOTIFICA
                    font.family: theme.defaultFont
                    font.pixelSize: 20
                    leftPadding: 25
                    rightPadding: leftPadding
                    // Layout.rightMargin: 25
                    // Layout.leftMargin: Layout.rightMargin
                    color: theme.fg
                }

                // Questa colonna contiene il blocco di testo E la riga dei bottoni sotto
                ColumnLayout {
                    id: textAndButtonsColumn
                    Layout.fillWidth: true
                    spacing: 4
                    Layout.rightMargin: appIcon.width// + appIcon.left

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

                    // La riga dei pulsanti vive dentro la colonna di destra
                    RowLayout {
                        id: buttonRow
                        Layout.fillWidth: true
                        Layout.topMargin: 4

                        // NUOVO: Aggiungiamo il margine a destra speculare a quello che c'è a sinistra prima del testo
                        // Layout.rightMargin: appIcon.width + mainLayout.spacing

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

                            // AGGIORNATO: Sottraiamo anche il nuovo rightMargin dal calcolo per non far sforare la TextArea
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
                                onClicked: eliminateNotificationReply.start() //modelData.sendInlineReply(responseInput.text)
                            }

                            SequentialAnimation {
                                id: eliminateNotificationReply

                                NumberAnimation {
                                    target: delegateRoot
                                    property: "x"
                                    from: 0
                                    to: delegateRoot.width + 100 // Sposta tutto il contenuto oltre il bordo destro della notifica
                                    duration: 300
                                    easing.type: Easing.InQuad
                                    // TRIGGER FONDAMENTALE: Cancella la notifica dal backend solo quando lo slide è finito!
                                    // onStopped: slideUpAnimation.start()
                                }
                                NumberAnimation {
                                    target: delegateRoot
                                    property: "height"
                                    // from: parent.height
                                    to: 0
                                    duration: 100
                                    easing.type: Easing.Linear
                                    // TRIGGER FONDAMENTALE: Cancella la notifica dal backend solo quando lo slide è finito!
                                    // onStopped: modelData.dismiss()
                                }
                                onStopped: modelData.sendInlineReply(responseInput.text)
                            }
                        }

                        Rectangle { // Tasto Rosso (Reply / Chiudi)
                            id: openCloseResponse
                            color: theme.red1
                            implicitHeight: parent.height
                            radius: implicitHeight / 2
                            // Layout.alignment: Qt.AlignRight

                            // AGGIORNATO: Ora quando è chiuso si allarga prendendo la larghezza della colonna meno il margine destro impostato
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
