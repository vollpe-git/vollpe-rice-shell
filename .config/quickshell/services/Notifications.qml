pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root
    NotificationServer {
        id: server
        onNotification: notification => {
            notification.tracked = true;
            root.numberOfNotificationsChanged();
            console.log(`new notification from ${notification.appName}`);
            for (let act of notification.actions) {
                console.log(`\t${act.text}`);
            }
        }
        Component.onCompleted: {
            console.log("Server avviato. Numero notifiche attuali: " + root.notifications.values.length);
        }
        inlineReplySupported: true
        actionsSupported: true
    }
    property var notifications: server.trackedNotifications
    property var numberOfNotifications: notifications.values?.length ?? 0
    onNumberOfNotificationsChanged: {
        console.log(`number of notifications: ${numberOfNotifications}`);
    }
}
