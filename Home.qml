// Home.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: homeRoot
    width: 1920
    height: 1080

    // Expose the content loader to NavBar for dynamic page loading
        property alias contentLoaderRef: contentLoader

    // Expose the NavBar to AppRoot for signOutConnections
        property alias navBarRef: nav

    // Brief comment: calendar state stored in Home so it survives page changes while the app is open
        property int calendarActiveMonth: -1
        property int calendarActiveYear: -1
        property int calendarActiveDay: -1

        Component.onCompleted: {
            console.log("NavBar alias exposed as navBarRef:", navBarRef)

            // Brief comment: test log to confirm Home-level calendar state exists and is initialized
            console.log("Home calendar state initialized -> Month:", calendarActiveMonth, "Year:", calendarActiveYear, "Day:", calendarActiveDay)
        }

    // Base background
    Rectangle {
        anchors.fill: parent
        color: "#101b27"

    }

    // Persistent NavBar
    NavBar {
        id: nav
        anchors.top: parent.top
        anchors.left: parent.left
        // width and height are defined in NavBar.qml
        Component.onCompleted: {
            console.log("NavBar loaded into Home") // confirm it appears in Home
        }
    }

    Loader {
        id: contentLoader
        width: 1800       // width of area next to NavBar
        height: 1080      // full height of the window
        source: ""        // initially empty
    }

    Component.onDestruction: {
        console.log("Home.qml destroyed:", homeRoot)
    }

}
