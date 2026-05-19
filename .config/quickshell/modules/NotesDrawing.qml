import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "../services"
import "../widgets"

Item {
    id: root
    property color backgroundColor: theme.bg1
    property color mainColor: theme.fg
    property color colorOne: theme.blue1
    property color colorTwo: theme.red1
    anchors.margins: 5
    anchors.fill: parent
    RowLayout {
        // Layout.fillWidth: true
        // Layout.fillHeight: true
        anchors.fill: parent
        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            GridLayout {
                columns: 4

                CanvasButton {
                    border.width: canvas.brushColor == color ? 4 : 0
                    color: root.mainColor
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: canvas.brushColor = root.mainColor
                    }
                }
                CanvasButton {
                    border.width: canvas.brushColor == color ? 4 : 0
                    color: root.colorOne
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: canvas.brushColor = root.colorOne
                    }
                }
                CanvasButton {
                    border.width: canvas.brushColor == color ? 4 : 0
                    color: root.colorTwo
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: canvas.brushColor = root.colorTwo
                    }
                }
                CanvasButton {
                    border.width: canvas.brushColor == color ? 4 : 0
                    color: root.backgroundColor
                    Text {
                        anchors.centerIn: parent
                        text: ""
                        font.family: theme.defaultFont
                        font.pixelSize: 14
                        color: theme.fg
                    }
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: canvas.brushColor = root.backgroundColor
                    }
                }

                CanvasButton {
                    color: canvas.brushSize == 1 ? "#80000000" : theme.bg
                    Rectangle {
                        anchors.centerIn: parent
                        color: canvas.brushColor
                        implicitHeight: 4
                        implicitWidth: implicitHeight
                        radius: implicitHeight / 2
                    }
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: canvas.brushSize = 1
                    }
                }
                CanvasButton {
                    color: canvas.brushSize == 2 ? "#80000000" : theme.bg
                    Rectangle {
                        anchors.centerIn: parent
                        color: canvas.brushColor
                        implicitHeight: 8
                        implicitWidth: implicitHeight
                        radius: implicitHeight / 2
                    }
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: canvas.brushSize = 2
                    }
                }
                CanvasButton {
                    color: canvas.brushSize == 3 ? "#80000000" : theme.bg
                    Rectangle {
                        anchors.centerIn: parent
                        color: canvas.brushColor
                        implicitHeight: 12
                        implicitWidth: implicitHeight
                        radius: implicitHeight / 2
                    }
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: canvas.brushSize = 3
                    }
                }
                CanvasButton {
                    color: canvas.brushSize == 4 ? "#80000000" : theme.bg
                    Rectangle {
                        anchors.centerIn: parent
                        color: canvas.brushColor
                        implicitHeight: 16
                        implicitWidth: implicitHeight
                        radius: implicitHeight / 2
                    }
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: canvas.brushSize = 4
                    }
                }
            }
            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: root.backgroundColor // Mostra il colore del tema a schermo
                clip: true
                z: -1
                radius: 10
                Canvas {
                    id: canvas
                    property color brushColor: root.mainColor
                    property int brushSize: 1
                    // Layout.fillHeight: true
                    // Layout.fillWidth: true
                    anchors.fill: parent
                    renderTarget: Canvas.Image
                    renderStrategy: Canvas.Cooperative
                    property bool isEraser: brushColor == root.backgroundColor
                    property real lastX
                    property real lastY

                    // Array per gestire l'Undo
                    property var pathHistory: []

                    onPaint: {
                        var ctx = getContext('2d');

                        // Impostiamo lo stile in base alle proprietà attuali del pennello
                        if (isEraser) {
                            ctx.globalCompositeOperation = "destination-out"; // Cancella i pixel rendendoli trasparenti
                            ctx.strokeStyle = "rgba(0,0,0,1)"; // Il colore non importa, basta che l'alfa sia 1 per cancellare
                        } else {
                            ctx.globalCompositeOperation = "source-over"; // Modalità di disegno standard (sovrascrive)
                            ctx.strokeStyle = brushColor;
                        }

                        ctx.lineWidth = isEraser ? brushSize * brushSize : brushSize;
                        ctx.strokeStyle = brushColor;
                        ctx.lineCap = "round";
                        ctx.lineJoin = "round";

                        ctx.beginPath();
                        ctx.moveTo(lastX, lastY);
                        // Nota: usiamo area.mouseX invece di lastX per il punto finale
                        ctx.lineTo(area.mouseX, area.mouseY);
                        ctx.stroke();

                        // Aggiorniamo le coordinate per il prossimo segmento
                        lastX = area.mouseX;
                        lastY = area.mouseY;
                    }

                    // function undo() {
                    //     if (pathHistory.length > 0) {
                    //         pathHistory.pop(); // Rimuove l'ultimo segmento

                    //         var ctx = getContext('2d');

                    //         // 1. Pulizia totale immediata del buffer
                    //         ctx.clearRect(0, 0, width, height);

                    //         // 2. Ridisegna tutto lo storico da zero
                    //         for (var i = 0; i < pathHistory.length; i++) {
                    //             var stroke = pathHistory[i];

                    //             ctx.beginPath();
                    //             ctx.lineWidth = stroke.size;
                    //             ctx.strokeStyle = stroke.color;
                    //             ctx.lineCap = "round";
                    //             ctx.lineJoin = "round";

                    //             ctx.moveTo(stroke.startX, stroke.startY);
                    //             ctx.lineTo(stroke.endX, stroke.endY);
                    //             ctx.stroke();
                    //             ctx.closePath(); // Chiudiamo esplicitamente il path
                    //         }

                    //         // 3. Ripristiniamo il colore selezionato per i prossimi tratti
                    //         ctx.strokeStyle = brushColor;
                    //         ctx.lineWidth = brushSize;

                    //         // 4. Importante: diciamo al motore di rendering di aggiornare la visualizzazione
                    //         requestPaint();
                    //     }
                    // }

                    function clearAll() {
                        var ctx = getContext('2d');
                        ctx.clearRect(0, 0, width, height);
                        pathHistory = [];
                        requestPaint();
                    }

                    MouseArea {
                        id: area
                        anchors.fill: parent
                        cursorShape: Qt.CrossCursor

                        onPressed: {
                            canvas.lastX = mouseX;
                            canvas.lastY = mouseY;
                        }

                        onPositionChanged: {
                            // Salviamo il segmento nello storico per l'undo
                            canvas.pathHistory.push({
                                startX: canvas.lastX,
                                startY: canvas.lastY,
                                endX: mouseX,
                                endY: mouseY,
                                color: canvas.brushColor,
                                size: canvas.brushSize
                            });
                            canvas.requestPaint();
                        }
                    }
                }
            }
        }
        ColumnLayout {
            spacing: 10
            Rectangle {
                implicitWidth: 20
                implicitHeight: implicitWidth
                color: theme.red1
                // Layout.fillHeight: true
                radius: implicitWidth / 2
                // border.width: 1
                // border.color: theme.red1
                // border.pixelAligned: true
                Text {
                    text: ""
                    font.family: theme.defaultFont
                    anchors.centerIn: parent
                    color: theme.fg4
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Global.notesActive = false
                }
            }
            MyButton {
                icon: "" // Icona copy
                color: theme.blue1

                Process {
                    id: copyProcess
                    // Per Wayland (Hyprland, Sway, ecc):
                    command: ["sh", "-c", "echo '" + base64Buffer + "' | base64 -d | wl-copy -t image/png"]
                    // Per X11 (i3, KDE, ecc) usa questo invece:
                    // command: ["sh", "-c", "echo '" + base64Buffer + "' | base64 -d | xclip -selection clipboard -t image/png"]

                    property string base64Buffer: ""
                    onExited: running = false
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // 1. Cattura l'immagine dal canvas come Base64
                        let dataUrl = canvas.toDataURL("image/png");
                        copyProcess.base64Buffer = dataUrl.replace(/^data:image\/png;base64,/, "");

                        // 2. Esegui il processo che la mette negli appunti
                        copyProcess.running = true;
                        console.log("🎨 Immagine copiata negli appunti!");
                    }
                }
            }
            MyButton {
                // trash button
                icon: ""
                color: theme.red1
                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    onClicked: canvas.clearAll()
                }
            }
            MyButton {
                icon: ""
                color: theme.magenta2
                SystemClock {
                    id: clock
                    precision: SystemClock.Minutes
                }

                Process {
                    id: saveProcess
                    // Usiamo la shell per decodificare il base64 e scrivere il file
                    command: ["sh", "-c", "echo '" + base64Buffer + "' | base64 -d > '" + targetPath + "'"]
                    property string base64Buffer: ""
                    property string targetPath: ""
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // 1. Ottieni i dati dal canvas
                        let dataUrl = canvas.toDataURL("image/png");
                        // Rimuovi l'intestazione della stringa
                        saveProcess.base64Buffer = dataUrl.replace(/^data:image\/png;base64,/, "");

                        // 2. Definisci il percorso
                        let dateStr = Qt.formatDate(clock.date, "dd-MM-yyyy");
                        let timeStr = Qt.formatDateTime(clock.date, "hh-mm");
                        saveProcess.targetPath = "/home/vollpe/Documents/Drawings/" + dateStr + "_" + timeStr + ".png";

                        console.log("Salvataggio forzato via shell in: " + saveProcess.targetPath);

                        // 3. Esegui il comando
                        saveProcess.running = true;
                    }
                }
            }
        }
    }

    component CanvasButton: Rectangle {
        implicitHeight: 20
        Layout.fillWidth: true
        radius: implicitHeight / 2
        color: theme.bg
        border.color: "#80000000"
        border.width: 0
    }
    component MyButton: Rectangle {
        implicitWidth: 20
        // color: theme.bg1
        Layout.fillHeight: true
        radius: implicitWidth / 2
        property string icon: "?"
        property color textColor: theme.fg4
        Text {
            font.pixelSize: 14
            font.bold: true
            text: parent.icon
            font.family: theme.defaultFont
            anchors.centerIn: parent
            color: parent.textColor
        }
    }
}
