import QtQuick 2.15
import QtQuick.Controls 2.15
import App.Database 1.0

Item {
    id: createAccountPanel
    width: 540
    height: 1080
    x: 0
    y: 0
    z: 1  // Ensure it's above other items

    property Item loginPanelRef
    property Loader loaderRef

    Rectangle {
        width: 540
        height: 1080
        color: "#ffffff"

        // Create Account header
        Text {
            id: createAccountHeader
            text: "Create Account"
            font.family: "Nexa"
            font.pointSize: 36
            font.weight: Font.Bold
            color: "black"
            anchors.horizontalCenter: parent.horizontalCenter
            y: 120
        }

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

        // Create Username Label
        Text {
            id: createUsernameLabel
            text: "Username"
            font.family: "Nexa"
            font.pointSize: 13
            font.weight: Font.Normal
            color: "black"
            x: 70
            y: 195
        }

        // Create Username Field
        Rectangle {
            width: 430
            height: 63
            color: "#f0f0f0"
            border.color: "#969696"
            border.width: 1
            radius: 5
            anchors.horizontalCenter: parent.horizontalCenter
            y: 219

            TextField {
                id: createUsernameField
                anchors.fill: parent
                anchors.margins: 5
                placeholderText: "Choose a username"
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

        // Create Password Label
        Text {
            id: createPasswordLabel
            text: "Password"
            font.family: "Nexa"
            font.pointSize: 13
            font.weight: Font.Normal
            color: "black"
            x: 70
            y: 305
        }

        // Create Password Field
        Rectangle {
            width: 430
            height: 63
            color: "#f0f0f0"
            border.color: "#969696"
            border.width: 1
            radius: 5
            anchors.horizontalCenter: parent.horizontalCenter
            y: 329

            TextField {
                id: createPasswordField
                anchors.fill: parent
                anchors.margins: 5
                placeholderText: "Create a password"
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

        // Confirm Password Label
        Text {
            id: confirmPasswordLabel
            text: "Confirm your password"
            font.family: "Nexa"
            font.pointSize: 13
            font.weight: Font.Normal
            color: "black"
            x: 70
            y: 415
        }

        // Create Password Field
        Rectangle {
            width: 430
            height: 63
            color: "#f0f0f0"
            border.color: "#969696"
            border.width: 1
            radius: 5
            anchors.horizontalCenter: parent.horizontalCenter
            y: 439

            TextField {
                id: confirmPasswordField
                anchors.fill: parent
                anchors.margins: 5
                placeholderText: "Re-enter your password"
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

        // Enter Email Address Label
        Text {
            id: enterEmailAddressLabel
            text: "Enter your email address"
            font.family: "Nexa"
            font.pointSize: 13
            font.weight: Font.Normal
            color: "black"
            x: 70
            y: 525
        }

        // Enter Email Address Field
        Rectangle {
            width: 430
            height: 63
            color: "#f0f0f0"
            border.color: "#969696"
            border.width: 1
            radius: 5
            anchors.horizontalCenter: parent.horizontalCenter
            y: 549

            TextField {
                id: enterEmailAddressField
                anchors.fill: parent
                anchors.margins: 5
                placeholderText: "name@example.com"
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

        // Sign Up button
        Item {
            id: signUpButton
            width: 165
            height: 66
            anchors.horizontalCenter: parent.horizontalCenter
            y: 723

            property bool hovered: false

            Image {
                id: signUpDefault
                anchors.fill: parent
                source: "qrc:/buttons/signUpButton.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: signUpButton.hovered ? 0 : 1

                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            Image {
                id: signUpHover
                anchors.fill: parent
                source: "qrc:/buttons/signUpButtonHover.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: signUpButton.hovered ? 1 : 0

                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            HoverHandler { onHoveredChanged: signUpButton.hovered = hovered }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    var username = createUsernameField.text
                    var password = createPasswordField.text
                    var email = enterEmailAddressField.text

                    if (username === "" || password === "" || email === "") {
                        console.log("Please fill all fields before signing up")
                        return
                    }

                    console.log("Attempting to add user with:", "Username:", username, "Password:", password, "Email:", email)

                    var success = DatabaseManager.addUser(username, password, email, false)
                    if (success) {
                        console.log("User created successfully:", username, email)
                        loaderRef.source = ""
                        loginPanelRef.visible = true
                    } else {
                        console.log("Failed to create user. Username or email may already exist.")
                    }

                }
            }
        }


        // TOS & PP label
        Text {
            id: tosAndPPLabel
            textFormat: Text.RichText
            text: "By creating an account you agree to the<br>"
                + "<a href=\"tos\" style=\"color:#28a0ae; text-decoration:none; font-weight:Bold;\">Terms of Service</a> and "
                + "<a href=\"privacy\" style=\"color:#28a0ae; text-decoration:none; font-weight:Bold;\">Privacy Policy</a>"

            font.family: "Nexa"
            font.pointSize: 10
            font.weight: Font.Light
            color: "black"

            width: parent.width
            horizontalAlignment: Text.AlignHCenter

            lineHeight: 1.1
            lineHeightMode: Text.ProportionalHeight

            anchors.horizontalCenter: parent.horizontalCenter
            y: 663

            onLinkActivated: function(link) {
                console.log(link, "clicked")
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
