pragma Singleton // Fondamentale: definisce che è un Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris // Il servizio specifico per i media player

Item{
    id: root

    property var activePlayer: Mpris.players.length > 0 ? Mpris.player[0] : null
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

    function setPosition(){
        return
    }
    function toggleRandom(){
        return
    }
    function switchLoop(){
        return
    }

}