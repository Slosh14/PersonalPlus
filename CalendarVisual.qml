import QtQuick 2.15

Item {
    id: calendarVisualRoot
    width: 300
    height: 309

    // Expose the internal rectangle for safe access from other panels
    property alias visualPanel: calendarVisual

    // Function to close any open interactive elements
    function closeInteractions() {
        yearDropdown.visible = false
        console.log("Visual panel dropdown closed")
    }

    Rectangle {
        id: calendarVisual
        anchors.fill: parent
        color: "#172837"
        radius: 5
        border.width: 1
        property bool active: false
        border.color: {
            console.log("calendarVisual.active changed to", active)
            return active ? "#2ca890" : "#485059"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Panel clicked: calendarVisual")
                calendarVisual.active = true

                // Deactivate other panels safely and close their interactions
                if (calendarRoot.optionsLoader.item && calendarRoot.optionsLoader.item.optionsPanel) {
                    calendarRoot.optionsLoader.item.optionsPanel.active = false
                    calendarRoot.optionsLoader.item.closeInteractions()
                }
                if (calendarRoot.mainLoader.item && calendarRoot.mainLoader.item.mainPanel) {
                    calendarRoot.mainLoader.item.mainPanel.active = false
                    calendarRoot.mainLoader.item.closeInteractions()
                }

                console.log("Panel updated: calendarVisual.active =", calendarVisual.active)
            }
        }

        Item {
            anchors.fill: parent
            anchors.margins: 28

            Image {
                id: upArrowButton
                source: "buttons/upArrowUnClicked.svg"
                width: 16
                height: 16
                fillMode: Image.PreserveAspectFit

                anchors.verticalCenter: monthYearRow.verticalCenter
                anchors.right: monthYearRow.left
                anchors.rightMargin: 10

                MouseArea {
                    width: 16
                    height: 13
                    anchors.centerIn: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onEntered: upArrowButton.source = "buttons/upArrowHover.svg"
                    onExited: upArrowButton.source = "buttons/upArrowUnClicked.svg"

                    onClicked: {
                        console.log("Up arrow clicked")
                        upArrowButton.source = "buttons/upArrowClicked.svg"
                        calendarVisual.active = true
                        if (calendarRoot.optionsLoader.item && calendarRoot.optionsLoader.item.optionsPanel) {
                            calendarRoot.optionsLoader.item.optionsPanel.active = false
                            calendarRoot.optionsLoader.item.closeInteractions()
                        }
                        if (calendarRoot.mainLoader.item && calendarRoot.mainLoader.item.mainPanel) {
                            calendarRoot.mainLoader.item.mainPanel.active = false
                            calendarRoot.mainLoader.item.closeInteractions()
                        }
                        console.log("Panel updated: calendarVisual.active =", calendarVisual.active)
                        upArrowClickTimer.start()
                    }
                }

                Timer {
                    id: upArrowClickTimer
                    interval: 100
                    repeat: false
                    onTriggered: {
                        upArrowButton.source = "buttons/upArrowUnClicked.svg"
                        console.log("Up arrow reverted to unclicked state")
                    }
                }
            }

            Row {
                id: monthYearRow
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top

                Text {
                    id: monthText
                    text: "September"
                    font.family: "Nexa"
                    font.weight: Font.Bold
                    font.pointSize: 14
                    color: "#f0f0f0"

                    Rectangle {
                        anchors.fill: parent
                        color: "#1f3548"
                        radius: 4
                        visible: monthMouse.containsMouse
                        z: -1
                    }

                    MouseArea {
                        id: monthMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: console.log("Hover entered: monthText")
                        onExited: console.log("Hover exited: monthText")

                        onClicked: {
                            console.log("Text clicked: monthText")
                            calendarVisual.active = true
                            if (calendarRoot.optionsLoader.item && calendarRoot.optionsLoader.item.optionsPanel) {
                                calendarRoot.optionsLoader.item.optionsPanel.active = false
                                calendarRoot.optionsLoader.item.closeInteractions()
                            }
                            if (calendarRoot.mainLoader.item && calendarRoot.mainLoader.item.mainPanel) {
                                calendarRoot.mainLoader.item.mainPanel.active = false
                                calendarRoot.mainLoader.item.closeInteractions()
                            }
                            console.log("Panel updated: calendarVisual.active =", calendarVisual.active)
                        }
                    }
                }

                Text {
                    text: ","
                    font.family: "Nexa"
                    font.weight: Font.Bold
                    font.pointSize: 14
                    color: "#f0f0f0"
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle { width: 8; height: 1; color: "transparent" }

                Text {
                    id: yearText
                    text: "2025"
                    font.family: "Nexa"
                    font.weight: Font.Bold
                    font.pointSize: 14
                    color: "#f0f0f0"

                    Rectangle {
                        anchors.fill: parent
                        color: "#1f3548"
                        radius: 4
                        visible: yearMouse.containsMouse
                        z: -1
                    }

                    MouseArea {
                        id: yearMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: console.log("Hover entered: yearText")
                        onExited: console.log("Hover exited: yearText")

                        onClicked: {
                            console.log("Text clicked: yearText")
                            calendarVisual.active = true
                            if (calendarRoot.optionsLoader.item && calendarRoot.optionsLoader.item.optionsPanel) {
                                calendarRoot.optionsLoader.item.optionsPanel.active = false
                                calendarRoot.optionsLoader.item.closeInteractions()
                            }
                            if (calendarRoot.mainLoader.item && calendarRoot.mainLoader.item.mainPanel) {
                                calendarRoot.mainLoader.item.mainPanel.active = false
                                calendarRoot.mainLoader.item.closeInteractions()
                            }
                            console.log("Panel updated: calendarVisual.active =", calendarVisual.active)
                            yearDropdown.visible = !yearDropdown.visible
                        }
                    }
                }
            }

            ListView {
                id: yearDropdown
                width: 80
                height: 120
                x: yearText.mapToItem(calendarVisual, 0, yearText.height).x
                y: yearText.mapToItem(calendarVisual, 0, yearText.height).y
                visible: false
                clip: true
                model: [2020,2021,2022,2023,2024,2025,2026,2027,2028,2029,2030]

                delegate: Rectangle {
                    width: parent.width
                    height: 30
                    color: "#1f3548"
                    border.color: "#485059"
                    border.width: 1

                    Text {
                        text: modelData
                        anchors.centerIn: parent
                        color: "#f0f0f0"
                        font.family: "Nexa"
                        font.pointSize: 12
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            yearText.text = modelData
                            yearDropdown.visible = false
                            console.log("Year selected:", modelData)
                            calendarVisual.active = true
                            if (calendarRoot.optionsLoader.item && calendarRoot.optionsLoader.item.optionsPanel) {
                                calendarRoot.optionsLoader.item.optionsPanel.active = false
                                calendarRoot.optionsLoader.item.closeInteractions()
                            }
                            if (calendarRoot.mainLoader.item && calendarRoot.mainLoader.item.mainPanel) {
                                calendarRoot.mainLoader.item.mainPanel.active = false
                                calendarRoot.mainLoader.item.closeInteractions()
                            }
                        }
                    }
                }
            }

            Image {
                id: downArrowButton
                source: "buttons/downArrowUnClicked.svg"
                width: 16
                height: 16
                fillMode: Image.PreserveAspectFit

                anchors.verticalCenter: monthYearRow.verticalCenter
                anchors.left: monthYearRow.right
                anchors.leftMargin: 10

                MouseArea {
                    width: 16
                    height: 13
                    anchors.centerIn: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onEntered: downArrowButton.source = "buttons/downArrowHover.svg"
                    onExited: downArrowButton.source = "buttons/downArrowUnClicked.svg"

                    onClicked: {
                        console.log("Down arrow clicked")
                        downArrowButton.source = "buttons/downArrowClicked.svg"
                        calendarVisual.active = true
                        if (calendarRoot.optionsLoader.item && calendarRoot.optionsLoader.item.optionsPanel) {
                            calendarRoot.optionsLoader.item.optionsPanel.active = false
                            calendarRoot.optionsLoader.item.closeInteractions()
                        }
                        if (calendarRoot.mainLoader.item && calendarRoot.mainLoader.item.mainPanel) {
                            calendarRoot.mainLoader.item.mainPanel.active = false
                            calendarRoot.mainLoader.item.closeInteractions()
                        }
                        console.log("Panel updated: calendarVisual.active =", calendarVisual.active)
                        downArrowClickTimer.start()
                    }
                }

                Timer {
                    id: downArrowClickTimer
                    interval: 100
                    repeat: false
                    onTriggered: {
                        downArrowButton.source = "buttons/downArrowUnClicked.svg"
                        console.log("Down arrow reverted to unclicked state")
                    }
                }
            }
        }
    }

    Component.onDestruction: {
        console.log("CalendarVisual.qml destroyed:", calendarVisualRoot)
    }
}
