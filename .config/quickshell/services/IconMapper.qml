pragma Singleton
import QtQuick

Item {
    id: root

    // Questo è il dizionario. A sinistra il nome che arriva dalla notifica (in minuscolo per sicurezza),
    // a destra l'icona del tuo font.
    readonly property var iconMap: {
        "spotify": "",
        "firefox": "",
        "librewolf": "",
        "discord": "",
        "vesktop": "",
        "steam": "",
        "thunar": "",
        "kitty": "",
        "foot": "",
        "alacritty": "",
        "telegram-desktop": "",
        "org.telegram.desktop": "",
        "signal": "",
        "vlc": "",
        "whatsie": "",
        "hyprshot": "󰹑"
    }

    // Questa funzione prende il testo dell'app, lo pulisce e sputa fuori l'icona.
    // Se non trova l'app nel dizionario, restituisce un'icona di default (es. una campana o un punto di domanda).
    function getIcon(appName, defaultIcon = "") {
        // console.log("[IconMapper] Input grezzo ricevuto:", appName);

        if (!appName || appName === "") {
            // console.log("[IconMapper] Nome nullo o vuoto, uso il default:", defaultIcon);
            return defaultIcon;
        }

        let cleanName = appName.toLowerCase().trim();
        // console.log("[IconMapper] Nome pulito per il match:", cleanName);

        if (iconMap[cleanName] !== undefined) {
            // console.log("[IconMapper] Trovato match esatto:", iconMap[cleanName]);
            return iconMap[cleanName];
        }

        for (let key in iconMap) {
            if (cleanName.includes(key)) {
                // console.log("[IconMapper] Trovato match parziale per key:", key, "->", iconMap[key]);
                return iconMap[key];
            }
        }

        // console.log("[IconMappe r] Nessun match trovato. Uso il default:", defaultIcon);
        return defaultIcon;
    }
}
