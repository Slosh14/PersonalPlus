import QtQuick 2.15

Item {
    id: calendarMainRoot
    width: 1488
    height: 1072

    // Expose the internal rectangle for safe access from other panels
    property alias mainPanel: calendarMain

    // Function to close any open interactive elements
    function closeInteractions() {
        // Currently no interactive elements, placeholder for future
        console.log("Main panel interactions closed")
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
            onClicked: {
                console.log("Panel clicked: calendarMain")
                calendarMain.active = true

                // Deactivate other panels safely and close their interactions
                if (calendarRoot.visualLoader.item && calendarRoot.visualLoader.item.visualPanel) {
                    calendarRoot.visualLoader.item.visualPanel.active = false
                    calendarRoot.visualLoader.item.closeInteractions()
                }
                if (calendarRoot.optionsLoader.item && calendarRoot.optionsLoader.item.optionsPanel) {
                    calendarRoot.optionsLoader.item.optionsPanel.active = false
                    calendarRoot.optionsLoader.item.closeInteractions()
                }

                console.log("Panel updated: calendarMain.active =", calendarMain.active)
            }
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
