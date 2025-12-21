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
            height: 500             // keep defined height
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

                Image {
                    anchors.fill: parent
                    anchors.margins: 1       // 1px border inside container
                    source: "qrc:/icons/navUnSelectedTasks.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }

            // Calendar icon container
            Rectangle {
                id: calendarContainer
                width: 120
                height: 118
                color: "transparent"
                anchors.top: tasksContainer.bottom  // directly below Tasks

                Image {
                    anchors.fill: parent
                    anchors.margins: 1       // 1px border inside container
                    source: "qrc:/icons/navUnSelectedCalendar.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }

        }

        MouseArea {
            id: signOutLink
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            width: signOutText.contentWidth
            height: signOutText.contentHeight - 5   // slightly smaller vertical clickable area
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                // Get the currently signed-in user from the database
                var currentUser = DatabaseManager.getCurrentlySignedInUser()
                console.log("Sign Out clicked for user:", currentUser)  // Confirm click and user

                if (currentUser !== "") {
                    console.log("Calling setCurrentlySignedIn for:", currentUser)
                    var setResult = DatabaseManager.setCurrentlySignedIn(currentUser, false)
                    console.log("setCurrentlySignedIn returned:", setResult)

                    console.log("Calling updateStaySignedIn for:", currentUser)
                    var stayResult = DatabaseManager.updateStaySignedIn(currentUser, false)
                    console.log("updateStaySignedIn returned:", stayResult)
                } else {
                    console.warn("No currently signed-in user found in database")
                }

                // Reset local auto-login properties
                autoLoginUsername = ""
                autoLoginStaySignedIn = false

                // Emit signal to switch views
                signOutRequested()
            }

            Text {
                id: signOutText
                text: "Sign Out"
                font.family: "Nexa"
                font.pointSize: 14
                font.weight: Font.Bold
                color: "#28a0ae"
                anchors.centerIn: parent
            }
        }

    }

    Component.onDestruction: {
        console.log("NavBar.qml destroyed:", navBar)
    }

}
