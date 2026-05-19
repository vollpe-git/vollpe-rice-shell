import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../services"
import "../widgets"

StackLayout {
    NotesManager {
        id: noteManager
        // distance: tab.thickness
        HyprlandFocusGrab {
            // active: root.margins.left == root.distance // Si attiva solo quando la finestra è visibile
            active: Global.notesActive
            windows: [noteManager, tab]
            // Questo segnale scatta quando clicchi fuori dalla finestra
            onCleared: {
                Global.notesActive = false;
            }
        }
    }
    NotesTab {
        id: tab
        Component.onCompleted: {
            console.log("Posizione Y globale del top: " + tab.y);
        }
    }
}
