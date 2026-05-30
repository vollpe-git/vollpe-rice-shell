import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import Quickshell.Services.SystemTray
import Quickshell.Hyprland
import "../services"
import "../widgets"

Item {
    id: root
    anchors.fill: parent
    anchors.bottomMargin: 30
    property bool noClosing: dropDownMedia.noClose || dropDownSink.noClose || dropDownSource.noClose
    anchors.margins: 30

    ColumnLayout {
        // implicitWidth: parent.width
        // anchors.left: parent.left
        // anchors.right: parent.right
        anchors.fill: parent
        RowLayout { // audio and media selector
            z: 999
            Layout.fillWidth: true
            // anchors.left: parent.left
            // anchors.right: parent.right
            spacing: 20
            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                Text { // icon
                    font.family: theme.defaultFont
                    color: theme.fg
                    font.pixelSize: 16
                    rightPadding: 5
                    text: ""
                }
                DropDownMenu { // media player
                    id: dropDownMedia
                    Layout.fillWidth: true
                    buttonColor: theme.bg
                    dropdownColor: theme.bg
                    hoverColor: theme.bg1
                    textColor: theme.fg
                    textColor2: theme.fg
                    dropdownBorderColor: theme.red1
                    dropdownBorderWidth: 2
                    dropdownWidth: root.width / 3
                    model: Media.players
                    textRole: "identity"
                    label: Media.activePlayer.identity || "media player"
                    onItemSelected: data => Media.setManualPlayer(data)
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Text { // icon
                    font.family: theme.defaultFont
                    color: theme.fg
                    font.pixelSize: 16
                    rightPadding: 5
                    text: "󰓃"
                }
                DropDownMenu { // sink
                    id: dropDownSink
                    Layout.fillWidth: true
                    buttonColor: theme.bg
                    dropdownColor: theme.bg
                    hoverColor: theme.bg1
                    textColor: theme.fg
                    textColor2: theme.fg
                    dropdownBorderColor: theme.red1
                    dropdownBorderWidth: 2
                    dropdownWidth: root.width / 3
                    model: Audio.sinks
                    textRole: "description"
                    label: Audio.sink.description || Audio.sink.name || "sink"
                    onItemSelected: data => Audio.setAudioSink(data)
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Text { // icon
                    font.family: theme.defaultFont
                    color: theme.fg
                    font.pixelSize: 16
                    rightPadding: 5
                    text: ""
                }
                DropDownMenu { // source
                    id: dropDownSource
                    Layout.fillWidth: true
                    buttonColor: theme.bg
                    dropdownColor: theme.bg
                    hoverColor: theme.bg1
                    textColor: theme.fg
                    textColor2: theme.fg
                    dropdownBorderColor: theme.red1
                    dropdownBorderWidth: 2
                    dropdownWidth: root.width / 3
                    model: Audio.sources
                    textRole: "description"
                    label: Audio.source.description || Audio.source.name || "source"
                    onItemSelected: data => Audio.setAudioSource(data)
                }
            }
        }
        // Assicurati che il contenitore padre (es. ColumnLayout) abbia una dimensione!
        Flickable {
            // 1. Diamo una dimensione al Flickable nel layout
            Layout.fillWidth: true
            Layout.fillHeight: true // O implicitHeight: 200 se vuoi che sia fisso

            // 2. Fondamentale: il Flickable deve sapere quanto è grande il contenuto
            contentHeight: flickableColumn.implicitHeight
            clip: true // Impedisce ai rettangoli di uscire fuori durante lo scroll

            ColumnLayout {
                id: flickableColumn
                // Layout.fillHeight: true
                // Layout.fillWidth: true
                width: parent.width
                RowLayout {
                    Layout.topMargin: 20
                    Layout.bottomMargin: 10
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 2
                        radius: implicitHeight / 2
                        color: theme.fg
                    }
                    Text {
                        font.family: theme.defaultFont
                        color: theme.fg
                        font.pixelSize: 16
                        text: "Trays"
                        leftPadding: 10
                        rightPadding: leftPadding
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 2
                        radius: implicitHeight / 2
                        color: theme.fg
                    }
                }
                GridLayout {
                    id: gridTrays
                    columns: 3

                    // 3. Il GridLayout deve seguire la larghezza del Flickable
                    implicitWidth: parent.width

                    rowSpacing: 10
                    columnSpacing: 10

                    Repeater {
                        model: SystemTray.items
                        delegate: Rectangle {
                            // 4. Definiamo una dimensione base per i delegati
                            // implicitWidth: 50
                            implicitHeight: 30

                            // Se vuoi che occupino tutto lo spazio della cella
                            Layout.fillWidth: true

                            color: theme.magenta2
                            radius: implicitHeight / 2

                            Text {
                                font.family: theme.defaultFont
                                font.pixelSize: 15
                                anchors.centerIn: parent
                                text: modelData.title
                                color: theme.fg4
                                font.bold: true
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                acceptedButtons: Qt.LeftButton || Qt.MiddleButton
                                onClicked: mouse => {
                                    if (mouse.button === Qt.LeftButton) {
                                        modelData.activate();
                                    } else if (mouse.button === Qt.MiddleButton) {
                                        modelData.secondaryActivate();
                                    }
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.topMargin: 40
                    Layout.bottomMargin: 10
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 2
                        radius: implicitHeight / 2
                        color: theme.fg
                    }
                    Text {
                        font.family: theme.defaultFont
                        color: theme.fg
                        font.pixelSize: 16
                        text: "Opened Windows"
                        leftPadding: 10
                        rightPadding: leftPadding
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 2
                        radius: implicitHeight / 2
                        color: theme.fg
                    }
                }
                GridLayout {
                    id: gridWindows
                    columns: 3

                    // 3. Il GridLayout deve seguire la larghezza del Flickable
                    implicitWidth: parent.width

                    rowSpacing: 10
                    columnSpacing: 10
                    Repeater {
                        model: {
                            // 1. Trasformiamo la mappa dei toplevels in un vero Array JS
                            // Usiamo .values per ottenere la lista delle finestre
                            let list = Hyprland.toplevels.values;

                            // 2. Creiamo una copia (.slice()) e ordiniamo (.sort())
                            // Usiamo l'ID del workspace per un ordinamento numerico preciso
                            list = list.slice().sort((a, b) => {
                                // Gestione di sicurezza nel caso il workspace sia null
                                let idA = a.workspace ? a.workspace.id : 999;
                                let idB = b.workspace ? b.workspace.id : 999;
                                return idA - idB;
                            });

                            // console.log("=================================================================");
                            for (let i in list) {
                                // console.log(list[i].workspace?.id);
                                if (!list[i].workspace?.id) {
                                    list.splice(i, 1);
                                }
                            }

                            return list;
                        }
                        delegate: Rectangle {
                            id: delegateRootWindows
                            // 4. Definiamo una dimensione base per i delegati
                            // implicitWidth: 50
                            implicitHeight: 30

                            // Se vuoi che occupino tutto lo spazio della cella
                            Layout.fillWidth: true

                            color: theme.red1
                            radius: implicitHeight / 2

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: parent.radius * 0.75
                                anchors.rightMargin: 2
                                Text {
                                    id: workspaceNumber
                                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                    text: modelData.title != "" ? modelData.title : "unknown"
                                    color: theme.fg4
                                    font.family: theme.defaultFont
                                    font.pixelSize: 12
                                    font.bold: true
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                    leftPadding: 5
                                }
                                Rectangle {
                                    Layout.topMargin: parent.anchors.rightMargin
                                    Layout.bottomMargin: Layout.topMargin
                                    Layout.fillHeight: true
                                    implicitWidth: height
                                    radius: height / 2
                                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                    color: theme.red2
                                    Text {
                                        font.family: theme.defaultFont
                                        font.pixelSize: 15
                                        anchors.centerIn: parent
                                        font.bold: modelData.workspace?.id > 0
                                        // Layout.alignment: Qt.AlignRight
                                        text: modelData.workspace?.id > 0 ? modelData.workspace.name : ""
                                        color: theme.fg4
                                    }
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: modelData.wayland.activate()
                            }
                        }
                    }
                }
            }
        }
    }
}
