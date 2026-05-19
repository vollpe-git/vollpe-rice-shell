pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    // Liste filtrate
    property list<PwNode> sinks: []
    property list<PwNode> sources: []
    property list<PwNode> streams: []

    // --- Selezione Nodi ---
    property PwNode manualSink: null
    readonly property PwNode sink: manualSink ? manualSink : Pipewire.defaultAudioSink

    property PwNode manualSource: null
    readonly property PwNode source: manualSource ? manualSource : Pipewire.defaultAudioSource

    // --- Proprietà Reattive ---
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0

    // --- Logica di Tracking (Il Cuore del Fix) ---

    // Questo tracker assicura che TUTTI i nodi conosciuti da Pipewire
    // siano "attivi" e popolino le loro proprietà (isSink, audio, ecc.)
    PwObjectTracker {
        objects: Pipewire.nodes.values
    }

    // Usiamo un Timer o una reazione diretta alla mappa dei nodi
    // Pipewire.nodes è un PwObjectMap, usiamo il segnale della mappa.
    Connections {
        target: Pipewire.nodes
        function onValuesChanged() {
            updateNodes();
        }
    }

    // Inizializzazione al caricamento
    Component.onCompleted: updateNodes()

    // Aggiungi questa funzione nel tuo Singleton
    function setAudioSink(newNode) {
        if (!newNode)
            return;

        // 1. Settiamo la preferenza nel servizio Pipewire (fondamentale)
        Pipewire.preferredDefaultAudioSink = newNode;

        // 2. Aggiorniamo il nostro riferimento locale per la UI
        root.manualSink = newNode;

        console.log("Sink impostato su: " + (newNode.description || newNode.name));
    }

    // Aggiungi questa funzione nel tuo Singleton
    function setAudioSource(newNode) {
        if (!newNode)
            return;

        // 1. Settiamo la preferenza nel servizio Pipewire (fondamentale)
        Pipewire.preferredDefaultAudioSource = newNode;

        // 2. Aggiorniamo il nostro riferimento locale per la UI
        root.manualSource = newNode;

        console.log("Source impostato su: " + (newNode.description || newNode.name));
    }

    function updateNodes() {
        let _sinks = [];
        let _sources = [];
        let _streams = [];

        const allNodes = Pipewire.nodes.values;

        for (let i = 0; i < allNodes.length; i++) {
            const node = allNodes[i];

            // Filtriamo in base alle proprietà effettive
            if (node.isStream) {
                if (node.audio)
                    _streams.push(node);
            } else {
                // Un nodo è un Sink se è un output audio fisico/virtuale
                if (node.isSink) {
                    _sinks.push(node);
                } else
                // Un nodo è un Source se è un input (microfono)
                if (node.isSource) {
                    _sources.push(node);
                }
            }
        }

        root.sinks = _sinks;
        root.sources = _sources;
        root.streams = _streams;
    }

    // --- Utility per i log (Corrette) ---
    onSinksChanged: {
        console.log("=== Sinks Aggiornati (" + sinks.length + ") ===");
        for (let s of sinks) {
            console.log(" - " + (s.description || s.name));
        }
    }

    onSourceChanged: {
        console.log("=== Sources Aggiornati (" + sources.length + ") ===");
        for (let s of sources) {
            console.log(" - " + (s.description || s.name));
        }
    }

    // --- Funzioni di Controllo (Invariate ma con check di sicurezza) ---
    function setVolume(newVolume) {
        if (sink && sink.audio) {
            sink.audio.muted = false;
            sink.audio.volume = Math.max(0, Math.min(1, newVolume));
        }
    }

    function toggleSinkMute() {
        if (sink && sink.audio) {
            sink.audio.muted = !sink.audio.muted;
        }
    }
}
