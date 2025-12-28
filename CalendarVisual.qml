import QtQuick 2.15

Item {
    id: calendarVisualRoot
    width: 300
    height: 309

    property alias visualPanel: calendarVisual
    property var interactiveElements: []

    function registerInteractiveElement(element) {
        if (interactiveElements.indexOf(element) === -1) {
            interactiveElements.push(element)
            console.log("Registered interactive element:", element)
        }
    }

    function closeInteractions(preserve) {
        for (var i = 0; i < interactiveElements.length; i++) {
            var element = interactiveElements[i]
            if (element !== preserve) {
                element.visible = false
            }
        }
        console.log("Visual panel interactions closed (preserve:", preserve, ")")
    }

    function activatePanel(preserveDropdown) {
        calendarVisual.active = true
        console.log("Panel activated: calendarVisual.active =", calendarVisual.active)

        closeInteractions(preserveDropdown)

        if (calendarRoot.optionsLoader.item && calendarRoot.optionsLoader.item.optionsPanel) {
            calendarRoot.optionsLoader.item.optionsPanel.active = false
            calendarRoot.optionsLoader.item.closeInteractions()
        }
        if (calendarRoot.mainLoader.item && calendarRoot.mainLoader.item.mainPanel) {
            calendarRoot.mainLoader.item.mainPanel.active = false
            calendarRoot.mainLoader.item.closeInteractions()
        }
    }

    Rectangle {
        id: calendarVisual
        anchors.fill: parent
        color: "#172837"
        radius: 5
        border.width: 1
        property bool active: false
        border.color: active ? "#2ca890" : "#485059"

        MouseArea {
            anchors.fill: parent
            onClicked: activatePanel(null)
        }

        Item {
            anchors.fill: parent
            anchors.margins: 28

            Row {
                id: monthYearRow
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                spacing: 0 // no spacing, each element has its own container

                // LEFT UP ARROW CONTAINER
                Item {
                    width: 16
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        id: upArrowButton
                        source: "buttons/upArrowUnClicked.svg"
                        width: 16
                        height: 16
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: upArrowButton.source = "buttons/upArrowHover.svg"
                            onExited: upArrowButton.source = "buttons/upArrowUnClicked.svg"
                            onClicked: {
                                console.log("Up arrow clicked")
                                upArrowButton.source = "buttons/upArrowClicked.svg"
                                activatePanel(null)
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
                }

                // MONTH CONTAINER
                Item {
                    width: monthText.implicitWidth + 5 // reduced 2px
                    height: monthText.implicitHeight + 6
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        id: monthBox
                        anchors.fill: parent
                        color: "#172837"
                        radius: 4

                        Text {
                            id: monthText
                            text: "September"
                            anchors.centerIn: parent
                            font.family: "Nexa"
                            font.weight: Font.Bold
                            font.pointSize: 14
                            color: "#f0f0f0"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                monthDropdown.visible = !monthDropdown.visible
                                activatePanel(monthDropdown)
                            }
                        }
                    }

                    ListView {
                        id: monthDropdown
                        width: parent.width
                        height: 240
                        anchors.top: monthBox.bottom
                        anchors.horizontalCenter: monthBox.horizontalCenter
                        clip: true
                        visible: false
                        model: ["January","February","March","April","May","June","July","August","September","October","November","December"]

                        delegate: Rectangle {
                            width: parent.width
                            height: 30
                            color: "#f0f0f0"

                            Text {
                                text: modelData
                                anchors.centerIn: parent
                                color: "#4b4b4b"
                                font.family: "Nexa"
                                font.weight: Font.Light
                                font.pointSize: 12
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: parent.color = "#d0d0d0"
                                onExited: parent.color = "#f0f0f0"
                                onClicked: {
                                    monthText.text = modelData
                                    monthDropdown.visible = false
                                    console.log("Month selected:", modelData)
                                    activatePanel(null)
                                }
                            }
                        }
                    }

                    Component.onCompleted: registerInteractiveElement(monthDropdown)
                }

                // COMMA CONTAINER
                Item {
                    width: 8
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: ","
                        anchors.centerIn: parent
                        font.family: "Nexa"
                        font.weight: Font.Bold
                        font.pointSize: 14
                        color: "#f0f0f0"
                    }
                }

                // YEAR CONTAINER
                Item {
                    width: yearText.implicitWidth + 5 // reduced 2px
                    height: yearText.implicitHeight + 6
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        id: yearBox
                        anchors.fill: parent
                        color: "#172837"
                        radius: 4

                        Text {
                            id: yearText
                            text: "2025"
                            anchors.centerIn: parent
                            font.family: "Nexa"
                            font.weight: Font.Bold
                            font.pointSize: 14
                            color: "#f0f0f0"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                yearDropdown.visible = !yearDropdown.visible
                                activatePanel(yearDropdown)
                            }
                        }
                    }

                    ListView {
                        id: yearDropdown
                        width: parent.width
                        height: 120
                        anchors.top: yearBox.bottom
                        anchors.horizontalCenter: yearBox.horizontalCenter
                        clip: true
                        visible: false
                        model: [2020,2021,2022,2023,2024,2025,2026,2027,2028,2029,2030]

                        delegate: Rectangle {
                            width: parent.width
                            height: 30
                            color: "#f0f0f0"

                            Text {
                                text: modelData
                                anchors.centerIn: parent
                                color: "#4b4b4b"
                                font.family: "Nexa"
                                font.weight: Font.Light
                                font.pointSize: 12
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: parent.color = "#d0d0d0"
                                onExited: parent.color = "#f0f0f0"
                                onClicked: {
                                    yearText.text = modelData
                                    yearDropdown.visible = false
                                    console.log("Year selected:", modelData)
                                    activatePanel(null)
                                }
                            }
                        }
                    }

                    Component.onCompleted: registerInteractiveElement(yearDropdown)
                }

                // RIGHT DOWN ARROW CONTAINER
                Item {
                    width: 16
                    height: 16
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        id: downArrowButton
                        source: "buttons/downArrowUnClicked.svg"
                        width: 16
                        height: 16
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: downArrowButton.source = "buttons/downArrowHover.svg"
                            onExited: downArrowButton.source = "buttons/downArrowUnClicked.svg"
                            onClicked: {
                                console.log("Down arrow clicked")
                                downArrowButton.source = "buttons/downArrowClicked.svg"
                                activatePanel(null)
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
        }
    }

    Component.onDestruction: {
        console.log("CalendarVisual.qml destroyed:", calendarVisualRoot)
    }
}
