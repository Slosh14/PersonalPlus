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
        color: "#ffffff"
        z: 1  // Ensure it's above the base rectangle

        // Sign in header
        Text {
            id: signInHeader
            text: "Sign In"
            font.family: "Nexa"
            font.pointSize: 42
            font.weight: Font.Bold
            color: "black"
            anchors.horizontalCenter: parent.horizontalCenter
            y: 260
        }

        // Username Field
        Rectangle {
            width: 430
            height: 63
            color: "#f0f0f0"
            border.color: "#969696"
            border.width: 1
            radius: 5
            anchors.horizontalCenter: parent.horizontalCenter
            y: 375

            TextField {
                id: usernameField
                anchors.fill: parent
                anchors.margins: 5
                placeholderText: "username"
                font.family: "Nexa"
                font.pointSize: 18
                font.weight: Font.Light
                color: "#b4b4b4"
                leftPadding: 22
                palette.placeholderText: "#b4b4b4"
                verticalAlignment: Text.AlignVCenter
                background: null
            }
        }

        // Password Field
        Rectangle {
            width: 430
            height: 63
            color: "#f0f0f0"
            border.color: "#969696"
            border.width: 1
            radius: 5
            anchors.horizontalCenter: parent.horizontalCenter
            y: 465

            TextField {
                id: passwordField
                anchors.fill: parent
                anchors.margins: 5
                placeholderText: "password"
                font.family: "Nexa"
                font.pointSize: 18
                font.weight: Font.Light
                color: "#b4b4b4"
                leftPadding: 22
                palette.placeholderText: "#b4b4b4"
                verticalAlignment: Text.AlignVCenter
                background: null
            }
        }

        // Checkbox images
        Item {
            id: rememberMeButton
            width: 24
            height: 24
            x: 55
            y: 552
            property bool checked: false

            // Log the value whenever it changes
            onCheckedChanged: console.log("Remember Me checked:", checked)

            // Unticked image
            Image {
                id: untickedImage
                source: "qrc:/buttons/rememberMeUnticked.svg"
                visible: !rememberMeButton.checked
                width: 24
                height: 24
                anchors.fill: parent

                MouseArea {
                    anchors.fill: parent
                    onClicked: rememberMeButton.checked = !rememberMeButton.checked
                    cursorShape: Qt.PointingHandCursor
                }
            }

            // Ticked image
            Image {
                id: tickedImage
                source: "qrc:/buttons/rememberMeTicked.svg"
                visible: rememberMeButton.checked
                width: 24
                height: 24
                anchors.fill: parent

                MouseArea {
                    anchors.fill: parent
                    onClicked: rememberMeButton.checked = !rememberMeButton.checked
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }

        // Label
        Text {
            id: staySignedIn
            text: "Stay signed in?"
            font.family: "Nexa"
            font.pointSize: 12
            font.weight: Font.Normal
            color: "black"
            x: rememberMeButton.x + rememberMeButton.width + 11
            y: rememberMeButton.y + (rememberMeButton.height - 12)/2  // vertically centered relative to checkbox
        }

        // Login button
        Item {
            id: loginButton
            width: 66
            height: 66
            anchors.horizontalCenter: parent.horizontalCenter
            y: 650

            property bool hovered: false

            // Default image
            Image {
                id: loginDefault
                anchors.fill: parent
                source: "qrc:/buttons/loginButton.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: loginButton.hovered ? 0 : 1

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }
            }

            // Hovered image
            Image {
                id: loginHover
                anchors.fill: parent
                source: "qrc:/buttons/loginButtonHover.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: loginButton.hovered ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }
            }

            HoverHandler {
                onHoveredChanged: loginButton.hovered = hovered
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: console.log("Login clicked")
            }
        }

        // "CAN'T SIGN IN?" link
        MouseArea {
            id: cantSignInLink
            anchors.horizontalCenter: parent.horizontalCenter
            y: 925
            width: cantSignIn.contentWidth
            height: cantSignIn.contentHeight - 10
            cursorShape: Qt.PointingHandCursor

            onClicked: console.log("Can't Sign In link clicked")

            Text {
                id: cantSignIn
                text: "CAN'T SIGN IN?"
                font.family: "Nexa"
                font.pointSize: 14
                font.weight: Font.Bold
                color: "#28a0ae"
                anchors.centerIn: parent
            }
        }

        // "CREATE ACCOUNT" link
        MouseArea {
            id: createAccountLink
            anchors.horizontalCenter: parent.horizontalCenter
            y: 945
            width: createAccountText.contentWidth
            height: createAccountText.contentHeight - 10
            cursorShape: Qt.PointingHandCursor

            onClicked: console.log("Create Account link clicked")

            Text {
                id: createAccountText
                text: "CREATE ACCOUNT"
                font.family: "Nexa"
                font.pointSize: 14
                font.weight: Font.Bold
                color: "#28a0ae"
                anchors.centerIn: parent
            }
        }
    }

    // Right background
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
            anchors.centerIn: parent
        }
    }
}
