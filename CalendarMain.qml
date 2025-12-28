import QtQuick 2.15

Item {
    id: calendarMainRoot
    width: 1488
    height: 1072

    // Expose the internal rectangle for safe access from other panels
    property alias mainPanel: calendarMain

    // List of interactive elements for centralized management
    property var interactiveElements: []

    // Helper function to register interactive elements
    function registerInteractiveElement(element) {
        if (interactiveElements.indexOf(element) === -1) {
            interactiveElements.push(element)
            console.log("Registered interactive element:", element)
        }
    }

    // Function to close any open interactive elements
    function closeInteractions(preserve) {
        for (var i = 0; i < interactiveElements.length; i++) {
            var element = interactiveElements[i]
            if (element !== preserve) {
                element.visible = false
            }
        }
        console.log("Main panel interactions closed (preserve:", preserve, ")")
    }

    // Function to activate this panel and deactivate others
    function activatePanel(preserve) {
        calendarMain.active = true
        console.log("Panel activated: calendarMain.active =", calendarMain.active)

        closeInteractions(preserve)

        if (calendarRoot.visualLoader.item && calendarRoot.visualLoader.item.visualPanel) {
            calendarRoot.visualLoader.item.visualPanel.active = false
            calendarRoot.visualLoader.item.closeInteractions()
        }
        if (calendarRoot.optionsLoader.item && calendarRoot.optionsLoader.item.optionsPanel) {
            calendarRoot.optionsLoader.item.optionsPanel.active = false
            calendarRoot.optionsLoader.item.closeInteractions()
        }
    }

    Rectangle {
        id: calendarMain
        anchors.fill: parent
        color: "#172837"
        radius: 5
        border.width: 1
        property bool active: false
        border.color: {
            console.log("calendarMain.active changed to", active)
            return active ? "#2ca890" : "#485059"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: activatePanel(null)
        }

        Item {
            anchors.fill: parent
            anchors.margins: 28
        }
    }

    Component.onDestruction: {
        console.log("CalendarMain.qml destroyed:", calendarMainRoot)
    }
}
