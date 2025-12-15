import QtQuick
import QtQuick.Controls

Item {
    id: loginRoot
    width: 1920
    height: 1080

    // Base white background
    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    // Left rectangle overlay
    Rectangle {
        id: loginPanel
        x: 0
        y: 0
        width: 540
        height: 1080
        color: "#ffffff" // Example color, change as needed
        z: 1  // Ensure it's above the base rectangle

        //Sign in header
        Text {
            text: "Sign In"
            font.family: "Nexa-Trial"
            font.pointSize: 42
            font.weight: Font.Bold
            color: "black"
            anchors.horizontalCenter: parent.horizontalCenter
            y: 262       // your chosen vertical position
        }
    }

    Image {
        id: loginBackground
        source: "qrc:/images/loginBackground.jpg"
        x: 540
        y: 0
        width: 1380
        height: 1080

        Image {
            id: logoMain
            source: "qrc:/images/logoMain.svg"
            x: 900
            y: 200
            anchors.centerIn: parent
        }
    }

}
