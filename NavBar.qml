// NavBar.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import App.Database 1.0

Item {
    id: navBar
    width: 120
    height: 1080

    signal signOutRequested()   // <-- added signal

    Component.onCompleted: {
        console.log("navBar loaded") // log to confirm NavBar is working
        console.log("DatabaseManager is available:", typeof DatabaseManager !== "undefined")
    }

    // Base background
    Rectangle {
        anchors.fill: parent
        color: "#e6e6e6"

        // Inner white rectangle to hold icons
        Rectangle {
            id: iconHolder
            width: parent.width      // fill horizontally
            height: 472             // keep defined height
            anchors.top: parent.top
            anchors.left: parent.left
            color: "white"

            // Tasks icon container
            Rectangle {
                id: tasksContainer
                width: 120
                height: 118
                color: "transparent"
                anchors.top: parent.top

                // Tracks selected state
                property bool tasksSelected: false

                Image {
                    id: tasksImage
                    anchors.fill: parent
                    anchors.margins: 1

                    // Selected > Hover > Default image priority
                    source: tasksContainer.tasksSelected
                            ? "qrc:/icons/navSelectedTasks.svg"
                            : tasksMouseArea.containsMouse
                                ? "qrc:/icons/navHoverTasks.svg"
                                : "qrc:/icons/navUnSelectedTasks.svg"
                }

                MouseArea {
                    id: tasksMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        tasksContainer.tasksSelected = true
                        calendarContainer.calendarSelected = false
                        fitnessContainer.fitnessSelected = false
                        budgetContainer.budgetSelected = false  // deselect Budget

                        console.log("Nav selection changed -> Tasks selected")
                    }

                }
            }


            // Calendar icon container
            Rectangle {
                id: calendarContainer
                width: 120
                height: 118
                color: "transparent"
                anchors.top: tasksContainer.bottom  // directly below Tasks

                // Tracks selected state
                property bool calendarSelected: false

                Image {
                    id: calendarImage
                    anchors.fill: parent
                    anchors.leftMargin: 1
                    anchors.rightMargin: 1
                    anchors.bottomMargin: 1

                    // Selected > Hover > Default image priority
                    source: calendarContainer.calendarSelected
                            ? "qrc:/icons/navSelectedCalendar.svg"
                            : calendarMouseArea.containsMouse
                                ? "qrc:/icons/navHoverCalendar.svg"
                                : "qrc:/icons/navUnSelectedCalendar.svg"
                }

                MouseArea {
                    id: calendarMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        calendarContainer.calendarSelected = true
                        tasksContainer.tasksSelected = false
                        fitnessContainer.fitnessSelected = false
                        budgetContainer.budgetSelected = false  // deselect Budget

                        console.log("Nav selection changed -> Calendar selected")
                    }

                }
            }


            // Fitness icon container
            Rectangle {
                id: fitnessContainer
                width: 120
                height: 118
                color: "transparent"
                anchors.top: calendarContainer.bottom  // directly below Calendar

                // Tracks selected state
                property bool fitnessSelected: false

                Image {
                    id: fitnessImage
                    anchors.fill: parent
                    anchors.leftMargin: 1
                    anchors.rightMargin: 1
                    anchors.bottomMargin: 1

                    // Selected > Hover > Default image priority
                    source: fitnessContainer.fitnessSelected
                            ? "qrc:/icons/navSelectedFitness.svg"
                            : fitnessMouseArea.containsMouse
                                ? "qrc:/icons/navHoverFitness.svg"
                                : "qrc:/icons/navUnSelectedFitness.svg"
                }

                MouseArea {
                    id: fitnessMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        fitnessContainer.fitnessSelected = true
                        tasksContainer.tasksSelected = false
                        calendarContainer.calendarSelected = false
                        budgetContainer.budgetSelected = false  // deselect Budget

                        console.log("Nav selection changed -> Fitness selected")
                    }

                }
            }

            // Budget icon container
            Rectangle {
                id: budgetContainer
                width: 120
                height: 118
                color: "transparent"
                anchors.top: fitnessContainer.bottom  // directly below Fitness

                // Tracks selected state
                property bool budgetSelected: false

                Image {
                    id: budgetImage
                    anchors.fill: parent
                    anchors.leftMargin: 1
                    anchors.rightMargin: 1
                    anchors.bottomMargin: 1

                    // Selected > Hover > Default image priority
                    source: budgetContainer.budgetSelected
                            ? "qrc:/icons/navSelectedBudget.svg"
                            : budgetMouseArea.containsMouse
                                ? "qrc:/icons/navHoverBudget.svg"
                                : "qrc:/icons/navUnSelectedBudget.svg"
                }

                MouseArea {
                    id: budgetMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        budgetContainer.budgetSelected = true
                        fitnessContainer.fitnessSelected = false
                        tasksContainer.tasksSelected = false
                        calendarContainer.calendarSelected = false

                        console.log("Nav selection changed -> Budget selected")
                    }

                }
            }


        }

        // Bottom bar rectangle
        Rectangle {
            id: navBarBottomContainer
            width: parent.width
            height: 35
            color: "white"
            anchors.bottom: parent.bottom

            // Gray background for Sign Out button
            Rectangle {
                id: signOutContainer
                color: "#e6e6e6"  // light gray
                x: 1
                y: 1
                width: 77   // fixed width
                height: parent.height - 2

                MouseArea {
                    id: signOutLink
                    anchors.fill: parent      // make the whole gray rectangle clickable
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onEntered: {
                        signOutContainer.color = "#d2d2d2"
                    }

                    onExited: {
                        signOutContainer.color = "#e6e6e6"
                    }

                    onClicked: {
                        var currentUser = DatabaseManager.getCurrentlySignedInUser()
                        console.log("Sign Out clicked for user:", currentUser)

                        if (currentUser !== "") {
                            DatabaseManager.setCurrentlySignedIn(currentUser, false)
                            DatabaseManager.updateStaySignedIn(currentUser, false)
                        }

                        autoLoginUsername = ""
                        autoLoginStaySignedIn = false

                        console.log("Sign Out action completed, full gray rect clickable") // test log
                        signOutRequested()
                    }

                    Text {
                        id: signOutText
                        text: "Sign Out"
                        font.family: "Nexa"
                        font.pointSize: 9
                        font.weight: Font.Bold
                        color: "#4b4b4b"

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 13   // adjust this value for exact horizontal offset
                    }

                    Component.onCompleted: {
                        console.log("Sign Out clickable area size:", width, height) // test log
                    }
                }
            }


            Rectangle {
                id: settingCogWheel
                color: "#e6e6e6"  // initial gray
                x: signOutContainer.x + signOutContainer.width + 1
                y: 1
                width: 40
                height: parent.height - 2

                property bool toggled: false  // tracks image/color state

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onEntered: {
                        if (!settingCogWheel.toggled) {
                            settingCogWheel.color = "#d2d2d2"
                        }
                    }

                    onExited: {
                        if (!settingCogWheel.toggled) {
                            settingCogWheel.color = "#e6e6e6"
                        }
                    }

                    onClicked: {
                        settingCogWheel.toggled = !settingCogWheel.toggled

                        if (settingCogWheel.toggled) {
                            settingCogWheel.color = "#101b27"
                            centerImage.source = "icons/settingCogSelected.svg"
                        } else {
                            settingCogWheel.color = "#e6e6e6"
                            centerImage.source = "icons/settingCogUnSelected.svg"
                        }

                        console.log("settingCogWheel clicked, toggled:", settingCogWheel.toggled)
                    }
                }

                Image {
                    id: centerImage
                    source: "icons/settingCogUnSelected.svg"  // initial image
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    width: parent.width * 0.6  // scale image to 60% of rect width
                    height: parent.height * 0.6
                }
            }




        }

    }

    Component.onDestruction: {
        console.log("NavBar.qml destroyed:", navBar)
    }

}
