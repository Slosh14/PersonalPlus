import QtQuick 2.15

Item {
    id: calendarOptionsRoot
    width: 300
    height: 759

    // Expose the internal rectangle for safe access from other panels
    property alias optionsPanel: calendarOptions

    // Function to close any open interactive elements
    function closeInteractions() {
        // Currently no interactive elements, placeholder for future
        console.log("Options panel interactions closed")
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
            onClicked: {
                console.log("Panel clicked: calendarOptions")
                calendarOptions.active = true

                // Deactivate other panels safely and close their interactions
                if (calendarRoot.visualLoader.item && calendarRoot.visualLoader.item.visualPanel) {
                    calendarRoot.visualLoader.item.visualPanel.active = false
                    calendarRoot.visualLoader.item.closeInteractions()
                }
                if (calendarRoot.mainLoader.item && calendarRoot.mainLoader.item.mainPanel) {
                    calendarRoot.mainLoader.item.mainPanel.active = false
                    calendarRoot.mainLoader.item.closeInteractions()
                }

                console.log("Panel updated: calendarOptions.active =", calendarOptions.active)
            }
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
