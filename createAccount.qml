import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: createAccountPanel
    width: 540
    height: 1080
    z: 1  // Ensure it's above other items

    property Item loginPanelRef
    property Loader loaderRef

    Rectangle {
        width: 540
        height: 1080
        color: "#ffffff"
        anchors.centerIn: parent

        // "CREATE ACCOUNT" link
        MouseArea {
            id: alreadyHaveAnAccount
            anchors.horizontalCenter: parent.horizontalCenter
            y: 945
            width: alreadyHaveAnAccountText.contentWidth
            height: alreadyHaveAnAccountText.contentHeight - 10
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                console.log("ALREADY HAVE AN ACCOUNT link clicked")
                loaderRef.source = ""
                loginPanelRef.visible = true
                console.log("Back button executed: createAccountPanel unloaded, loginPanel visible")
            }


            Text {
                id: alreadyHaveAnAccountText
                text: "ALREADY HAVE AN ACCOUNT"
                font.family: "Nexa"
                font.pointSize: 14
                font.weight: Font.Bold
                color: "#28a0ae"
                anchors.centerIn: parent
            }
        }
    }

    Component.onCompleted: {
        console.log("createAccountPanel loaded")
    }

    Component.onDestruction: {
        console.log("createAccountPanel destroyed")
    }

}
