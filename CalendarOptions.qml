import QtQuick 2.15

Item {
    id: calendarOptionsRoot
    width: 300
    height: 759

    // Expose the internal rectangle for safe access from other panels
    property alias optionsPanel: calendarOptions

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
        console.log("Options panel interactions closed (preserve:", preserve, ")")
    }

    // Function to activate this panel and deactivate others
    function activatePanel(preserve) {
        calendarOptions.active = true
        console.log("Panel activated: calendarOptions.active =", calendarOptions.active)

        closeInteractions(preserve)

        if (calendarRoot.visualLoader.item && calendarRoot.visualLoader.item.visualPanel) {
            calendarRoot.visualLoader.item.visualPanel.active = false
            calendarRoot.visualLoader.item.closeInteractions()
        }
        if (calendarRoot.mainLoader.item && calendarRoot.mainLoader.item.mainPanel) {
            calendarRoot.mainLoader.item.mainPanel.active = false
            calendarRoot.mainLoader.item.closeInteractions()
        }
    }

    Rectangle {
        id: calendarOptions
        anchors.fill: parent
        color: "#172837"
        radius: 1
        border.width: 1
        property bool active: false
        border.color: {
            console.log("calendarOptions.active changed to", active)
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
        console.log("CalendarOptions.qml destroyed:", calendarOptionsRoot)
    }
}
