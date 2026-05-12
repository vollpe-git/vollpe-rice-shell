pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Item {
    id: root

    // --- PROPRIETÀ ESPOSTE ---
    // Queste proprietà verranno lette da shell.qml (es. Audio.volume)

    // readonly property int volume: (audioInterface && !isNaN(audioInterface.volume)) 
    //                               ? Math.round(audioInterface.volume * 100) 
    //                               : 0
    // readonly property bool muted: audioInterface ? audioInterface.muted : false
    // readonly property string name: trackedSink ? (trackedSink.nickname || trackedSink.name) : "Nessun Dispositivo"

    property int step: 1


    // --- FUNZIONI ---

    function getVolume(){
        return (root.getAudioInterface() && !isNaN(root.getAudioInterface().volume)) ? Math.round(root.getAudioInterface().volume * 100)  : 0
    }

    function isMuted(){
        return root.getAudioInterface() ? root.getAudioInterface().muted : false
    }

    function getName(){
        return root.getTrackedSink() ? (root.getTrackedSink().nickname || root.getTrackedSink().name) : "Nessun Dispositivo"
    }

    function setVolume(volPerc){
        if(root.getAudioInterface()){
            if(volPerc > 100){
                console.log("setted volume higher than 100");
                volPerc = 100;
            } else if(volPerc < 0){
                console.log("setted volume lower than 0");
                volPerc = 0;
            }
            let vol = parseFloat(volPerc/100);
            root.getAudioInterface().volume = vol;
        }
    }

    function volumeUp(){
        setVolume(root.getVolume()+step)
    }

    function volumeDown(){
        setVolume(root.getVolume()-step)
    }

    function toggleMute(){
        if(root.getAudioInterface()){
            root.getAudioInterface().muted = !root.isMuted();
        }
    }




    PwObjectTracker {
        id: sinkTracker
        objects: {
            if (Pipewire.ready && Pipewire.defaultAudioSink) {
                return [Pipewire.defaultAudioSink];
            }
            return [];
        }
    }

    // Spostiamo il Connection FUORI dal tracker (come già discusso)
    Connections {
        target: Pipewire
        function onDefaultAudioSinkChanged() {
            console.log("Audio: Il dispositivo di output predefinito è cambiato!");
        }
    }

    // 3. Estraiamo l'oggetto tracciato dai risultati del tracker.
    // 'results' contiene gli oggetti che Pipewire ha popolato con successo.
    readonly property var trackedSink: sinkTracker.objects.length > 0 ? sinkTracker.objects[0] : null
    function getTrackedSink(){
        return sinkTracker.objects.length > 0 ? sinkTracker.objects[0] : null;
    }

    // 4. Accediamo all'interfaccia audio (PwNodeAudio) dell'oggetto tracciato.
    // È qui che risiedono fisicamente le proprietà .volume e .muted
    // readonly property var audioInterface: trackedSink ? trackedSink.audio : null
    function getAudioInterface(){
        return root.getTrackedSink() ? root.getTrackedSink().audio : null;
    }

    // --- DEBUG (Opzionale, puoi rimuoverlo dopo i test) ---
    // onAudioInterfaceChanged: {
    //     if (root.getAudioInterface()) {
    //         console.log("Audio.qml: Collegato a: " + root.getName() + " | Vol: " + root.getVolume() + "%");
    //     } else {
    //         console.log("Audio.qml: Ricerca dispositivo in corso...");
    //     }
    // }
}