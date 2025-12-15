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
            id: signInHeader1
            text: "Sign In"
            font.family: "Nexa-Trial"
            font.pointSize: 42
            font.weight: Font.Bold
            color: "black"
            anchors.horizontalCenter: parent.horizontalCenter
            y: 260       // your chosen vertical position
        }

        TextField {
            id: usernameField
            width: 430
            height: 63
            placeholderText: "username"
            anchors.horizontalCenter: parent.horizontalCenter
            y: 375
            font.family: "Nexa-Trial"
            font.pointSize: 18
            font.weight: Font.Light
            color: "#b4b4b4"          // applies to both typed text and placeholder

            // Custom background
            background: Rectangle {
                color: "#f0f0f0"          // background color of the TextField
                border.color: "#969696"   // border color
                border.width: 2           // adjust thickness if needed
                radius: 5                 // optional: rounded corners
            }

            // Explicitly style the placeholder text
                leftPadding: 22
                palette.placeholderText: "#b4b4b4"
                verticalAlignment: Text.AlignVCenter
        }

        TextField {
            id: passwordField
            width: 430
            height: 63
            placeholderText: "password"
            anchors.horizontalCenter: parent.horizontalCenter
            y: 465
            font.family: "Nexa-Trial"
            font.pointSize: 18
            font.weight: Font.Light
            color: "#b4b4b4"          // applies to both typed text and placeholder

            // Custom background
            background: Rectangle {
                color: "#f0f0f0"          // background color of the TextField
                border.color: "#969696"   // border color
                border.width: 2           // adjust thickness if needed
                radius: 5                 // optional: rounded corners
            }

            // Explicitly style the placeholder text
                leftPadding: 22
                palette.placeholderText: "#b4b4b4"
                verticalAlignment: Text.AlignVCenter
        }

        Image {
            id: loginButton
            source: "qrc:/images/loginButton.svg"
            anchors.horizontalCenter: parent.horizontalCenter
            y: 650

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
