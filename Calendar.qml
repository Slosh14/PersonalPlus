import QtQuick 2.15

Item {
    id: calendarRoot
    width: 1800
    height: 1080

    // Expose Loaders as aliases for child panels
    property alias visualLoader: visualLoader
    property alias optionsLoader: optionsLoader
    property alias mainLoader: mainLoader

    // === Load CalendarVisual Panel ===
    Loader {
        id: visualLoader
        x: 124
        y: 4
        width: 300
        height: 309
        source: "CalendarVisual.qml"
        onLoaded: {
            console.log("CalendarVisual loaded via Loader:", visualLoader.item)
        }
    }

    // === Load CalendarOptions Panel ===
    Loader {
        id: optionsLoader
        x: 124
        y: 317
        width: 300
        height: 759
        source: "CalendarOptions.qml"
        onLoaded: {
            console.log("CalendarOptions loaded via Loader:", optionsLoader.item)
        }
    }

    // === Load CalendarMain Panel ===
    Loader {
        id: mainLoader
        x: 428
        y: 4
        width: 1488
        height: 1072
        source: "CalendarMain.qml"
        onLoaded: {
            console.log("CalendarMain loaded via Loader:", mainLoader.item)
        }
    }

    Component.onDestruction: {
        console.log("Calendar.qml destroyed:", calendarRoot)
    }
}
