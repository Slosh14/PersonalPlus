import QtQuick 2.15

Item {
    id: calendarRoot
    width: 1800
    height: 1080

    Rectangle {
        id: calendarVisual
        x: 124
        y: 4
        width: 300
        height: 309
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
                console.log("Panel clicked: calendarVisual | current states -> visual:", calendarVisual.active, "options:", calendarOptions.active, "main:", calendarMain.active)
                calendarVisual.active = true
                calendarOptions.active = false
                calendarMain.active = false
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
                        calendarVisual.active = true       // activate panel
                        calendarOptions.active = false
                        calendarMain.active = false
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

                // Month clickable text
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
                            calendarOptions.active = false
                            calendarMain.active = false
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

                Rectangle {
                    width: 8
                    height: 1
                    color: "transparent"
                }

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
                            calendarOptions.active = false
                            calendarMain.active = false
                            console.log("Panel updated: calendarVisual.active =", calendarVisual.active)
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
                        calendarVisual.active = true       // activate panel
                        calendarOptions.active = false
                        calendarMain.active = false
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

    Rectangle {
        id: calendarOptions
        x: 124
        y: 317
        width: 300
        height: 759
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
                console.log("Panel clicked: calendarOptions | current states -> visual:", calendarVisual.active, "options:", calendarOptions.active, "main:", calendarMain.active)
                calendarVisual.active = false
                calendarOptions.active = true
                calendarMain.active = false
                console.log("Panel updated: calendarOptions.active =", calendarOptions.active)
            }
        }

        Item {
            anchors.fill: parent
            anchors.margins: 28
        }
    }

    Rectangle {
        id: calendarMain
        x: 428
        y: 4
        width: 1488
        height: 1072
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
                console.log("Panel clicked: calendarMain | current states -> visual:", calendarVisual.active, "options:", calendarOptions.active, "main:", calendarMain.active)
                calendarVisual.active = false
                calendarOptions.active = false
                calendarMain.active = true
                console.log("Panel updated: calendarMain.active =", calendarMain.active)
            }
        }

        Item {
            anchors.fill: parent
            anchors.margins: 28
        }
    }

    Component.onDestruction: {
        console.log("Calendar.qml destroyed:", calendarRoot)
    }
}
