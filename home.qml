// Home.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: homeRoot
    width: 1920
    height: 1080

    // Expose the NavBar to AppRoot for signOutConnections
        property alias navBarRef: nav

        Component.onCompleted: {
            console.log("NavBar alias exposed as navBarRef:", navBarRef)
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

    Component.onDestruction: {
        console.log("Home.qml destroyed:", homeRoot)
    }

}
