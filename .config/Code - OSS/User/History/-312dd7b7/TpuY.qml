pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Item {
    id: root

    // --- PROPRIETÀ ESPOSTE ---
    // Queste proprietà verranno lette da shell.qml (es. Audio.volume)

    readonly property int volume: audioInterface ? Math.round(audioInterface.volume * 100) : 0
    readonly property bool muted: audioInterface ? audioInterface.muted : false
    readonly property string name: trackedSink ? trackedSink.nickname : null

    property int step: 1


    // --- FUNZIONI ---

    function setVolume(volPerc){
        if(audioInterface){
            if(volPerc > 100){
                console.log("setted volume higher than 100");
                volPerc = 100;
            } else if(volPerc < 0){
                console.log("setted volume lower than 0");
                volPerc = 0;
            }
            let vol = parseFloat(volPerc/100);
            audioInterface.volume = vol;
        }
    }

    function volumeUp(){
        setVolume(audioInterface.volume+step)
    }

    function volumeDown(){
        setVolume(audioInterface.volume-step)
    }

    function toggleMute(){
        if(audioInterface){
            audioInterface.muted = !audioInterface.muted;
        }
    }




    PwObjectTracker{
        id: sinkTracker
        objects: (Pipewire.defaultAudioSink && Pipewire.ready) ? [Pipewire.defaultAudioSink] : []
    }
    // Connections{
    //     target: Pipewire
    //     function onReadyChanged() {
    //         if (Pipewire.ready) {
    //             console.log("Audio: Pipewire tornato pronto, ricollego il tracker...");
    //             // Non serve fare nulla di manuale, la proprietà 'objects' 
    //             // si ri-valuterà da sola grazie alla reattività di QML
    //         }
    //     }
    // }

    // 3. Estraiamo l'oggetto tracciato dai risultati del tracker.
    // 'results' contiene gli oggetti che Pipewire ha popolato con successo.
    readonly property var trackedSink: sinkTracker.objects.length > 0 ? sinkTracker.objects[0] : null

    // 4. Accediamo all'interfaccia audio (PwNodeAudio) dell'oggetto tracciato.
    // È qui che risiedono fisicamente le proprietà .volume e .muted
    readonly property var audioInterface: trackedSink ? trackedSink.audio : null

    // --- DEBUG (Opzionale, puoi rimuoverlo dopo i test) ---
    onAudioInterfaceChanged: {
        if (audioInterface) {
            console.log("Audio.qml: Dispositivo tracciato con successo: " + root.defaultSink.name);
            console.log("Audio.qml: Volume iniziale: " + volume + "%");
        } else {
            console.log("Audio.qml: In attesa di tracciamento dispositivo...");
        }
    }
}