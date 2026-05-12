pragma Singleton // Fondamentale: definisce che è un Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris // Il servizio specifico per i media player

Item{
    id: root

    property var activePlayer: {
        if(players.length > 0){
            for(let plap of players){
                if(plap.playbackState === MprisPlaybackState.Playing) return plap;
            }
            for(let plapp of players){
                if(plapp.playbackState == MprisPlaybackState.Paused) return plapp;
            }
        }
        return null
    }
    property var players: Mpris.players.values
    property var cover: activePlayer ? activePlayer.trackArtUrl : null
    property string artist: activePlayer ? (activePlayer.trackArtist || "unknown") : null
    property string title: activePlayer ? (activePlayer.trackTitle || "unknown") : null
    property string album: activePlayer ? (activePlayer.trackAlbum || "unknown") : null
    // property var loop: activePlayer ? activePlayer.loopState : null
    // property bool random: activePlayer ? activePlayer.shuffle : null
    // property bool canSkip: activePlayer ? activePlayer.loopState : null
    // property bool canBack: false
    // property bool random: false
    property real length: activePlayer ? (activePlayer.lengthSupported ? activePlayer.length : 0) : null
    property real position: activePlayer ? (activePlayer.positionSupported ? activePlayer.position : 0) : null
    property real timeBarFullSupport: activePlayer?.positionSupported && activePlayer?.lengthSupported
    property string identity: activePlayer ? activePlayer.identity : null
    
    property string positionString: {
        if (position){
            let min = Math.round(position/60);
            let sec = position-(min*60);
            return (`${min}:${sec}`);
        } else {
            return "??:??"
        }
    }

    property string lengthString: {
        if (length){
            let min = Math.round(length/60);
            let sec = length-(min*60);
            return (`${min}:${sec}`);
        } else {
            return "??:??"
        }
    }

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
        console.log(`active player: ${root.activePlayer?.identity}`);
        // debugPlayer(root.players[1]);
    }

    onPlayersChanged: {
        let toPrint = ""
        for(let pla of root.players){
            toPrint += `${pla.identity}: ${pla.playbackState?.toString()}, `
        }
        console.log(`players: ${toPrint}`)
    }

    function debugPlayer(player) {
        if (!player) return;
        console.log("--- DEBUG PLAYER: " + player.identity + " ---");
        for (var prop in player) {
            try {
                console.log(prop + ": " + player[prop]);
            } catch (e) {
                // Alcune proprietà potrebbero essere protette o non leggibili
                console.log(prop + ": [Errore di lettura]");
            }
        }
    }
    
    onCoverChanged: console.log("Nuova cover URL:", cover)
    onLengthChanged: console.log(`new media length: ${length}`)
    onPositionChanged: console.log(`new media position: ${position}`)
}