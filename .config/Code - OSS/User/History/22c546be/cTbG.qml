pragma Singleton // Fondamentale: definisce che è un Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris // Il servizio specifico per i media player

Item{
    id: root

    property var activePlayer: {
        if(players.length > 0){
            for(let pla of players){
                if(pla.playBackState == MprisPlaybackState.Playing) return pla;
            }
            for(let pla of players){
                if(pla.playBackState == MprisPlaybackState.Paused) return pla;
            }
        }
        return null
    }
    property var players: Mpris.players.values
    property var cover: activePlayer ? activePlayer.trackArtUrl : null
    property string artist: activePlayer ? (activePlayer.trackArtist || "unknown") : null
    property string name: activePlayer ? (activePlayer.trackTitle || "unknown") : null
    property string album: activePlayer ? (activePlayer.trackAlbum || "unknown") : null
    // property var loop: activePlayer ? activePlayer.loopState : null
    // property bool random: activePlayer ? activePlayer.shuffle : null
    // property bool canSkip: activePlayer ? activePlayer.loopState : null
    // property bool canBack: false
    // property bool random: false
    property real length: activePlayer ? (activePlayer.lengthSupported ? activePlayer.length : 0) : null
    property real position: activePlayer ? (activePlayer.positionSupported ? activePlayer.position : 0) : null
    property string mediaProgram: activePlayer ? activePlayer.identity : null

    function setPosition(newPosition){
        root.position = newPosition <= root.length ? (newPosition >= 0 ? newPosition : 0) : root.length;
    }
    function toggleRandom(){
        if(activePlayer){
            activePlayer.shuffle = !activePlayer?.shuffle;
        }
    }
    function switchLoop(){
        if (!activePlayer) return;
    
        // Logica di switch tra gli stati MPRIS standard
        if (loopStatus === "None") {
            activePlayer.loopStatus = "Track";
        } else if (loopStatus === "Track") {
            activePlayer.loopStatus = "Playlist";
        } else {
            activePlayer.loopStatus = "None";
        }
    }

    onActivePlayerChanged: {
        console.log(`active player: ${activePlayer?.identity}`);
    }

    onPlayersChanged: {
        let toPrint = ""
        for(let pla of root.players){
            toPrint += `${pla.identity}, `
        }
        console.log(`players: ${toPrint}`)
    }
}