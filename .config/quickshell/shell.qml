import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import "./services"
import "./widgets"
import "./modules"

ShellRoot {
    property QtObject theme: QtObject {
        readonly property color bg: "#1d1d1b"
        readonly property color bg1: "#3c3c3c"
        readonly property color bg2: "#0Aff7ef6"
        readonly property color bg3: "#535353"
        readonly property color bg4: "#ffffff"

        readonly property color fg: "#ffffff"
        readonly property color fg1: "#debad5"
        readonly property color fg2: "#00ffff"
        readonly property color fg3: "#f2a7bc"
        readonly property color fg4: "#1d1d1b"
        readonly property color fgOff: "#80ffffff"

        readonly property color black1: "#1d1d1b"
        readonly property color black2: "#3c3c3c"

        readonly property color red1: "#f687a7"
        readonly property color red2: "#f2a7bc"

        readonly property color green1: "#15ff00"
        readonly property color green2: "#a2ff96"

        readonly property color yellow1: "#ffd900"
        readonly property color yellow2: "#fff475"

        readonly property color blue1: "#0095ff"
        readonly property color blue2: "#00b3ff"

        readonly property color magenta1: "#643bac"
        readonly property color magenta2: "#965ebd"

        readonly property color cyan1: "#43c7ff"
        readonly property color cyan2: "#00ffff"

        readonly property color white1: "#debad5"
        readonly property color white2: "#ffffff"

        // dimensions
        readonly property int barHeigth: 40
        readonly property int barPadding: 5

        readonly property int leftBarWidth: 20

        // font
        readonly property string defaultFont: "JetBrainsMono Nerd Font"
    }
    Bar {}
}
