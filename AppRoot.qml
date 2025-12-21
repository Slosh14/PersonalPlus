import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: appRoot
    width: 1920
    height: 1080
    visible: true

    title: "Personal Plus"

    // Lock window size
    minimumWidth: 1920
    maximumWidth: 1920
    minimumHeight: 1080
    maximumHeight: 1080

    // Connections object to listen for NavBar signOutRequested
    Connections {
        id: signOutConnections
        target: null    // start safe

        function onSignOutRequested() {
            console.log("Sign Out signal received in AppRoot, switching to Login.qml")
            mainLoader.setSource("Login.qml")
        }
    }


    Loader {
        id: mainLoader
        anchors.fill: parent
        source: autoLoginStaySignedIn ? "Home.qml" : "Login.qml"

        onLoaded: {
            console.log("mainLoader loaded:", source)
            console.log("mainLoader.item:", item)

            if (!item) {
                console.warn("Loader.item is null!")
                return
            }

            // Log children to see if NavBar exists
            console.log("Children of mainLoader.item:")
            for (var i = 0; i < item.children.length; i++) {
                console.log("child", i, "id:", item.children[i].id)
            }

            // Delayed assignment to ensure NavBar exists
            function trySetNavTarget() {
                if ("navBarRef" in item) {  // <-- check property exists instead of repeated retry
                    signOutConnections.target = item.navBarRef
                    console.log("signOutConnections target set to NavBar")
                } else {
                    console.log("Loaded item has no NavBarRef, skipping assignment")
                    // Do NOT retry infinitely
                }
            }
            trySetNavTarget()
        }
    }


}
