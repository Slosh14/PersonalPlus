import QtQuick
import QtQuick.Controls
import App.Database 1.0

Item {
    id: loginRoot
    width: 1920
    height: 1080

    property Loader loaderRef   // <-- add this here

    Component.onCompleted: {
            if (!loaderRef) {
                // Assign loaderRef directly from parent loader
                loaderRef = Qt.binding(function() { return parent; })
                console.log("loaderRef assigned in login.qml:", loaderRef)
            }

            var lastUser = DatabaseManager.getLastSignedInUser()
            if (lastUser.staySignedIn) {
                usernameField.text = lastUser.username
                staySignedInButton.checked = true
            }
        }

        Component.onDestruction: {
            console.log("login.qml destroyed:", loginRoot)
        }


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
                rightPadding: 65   // leave space for toggle circle
                palette.placeholderText: "#b4b4b4"
                verticalAlignment: Text.AlignVCenter
                background: null
            }
        }

        // Password Field with circular toggle
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
                rightPadding: 65   // leave space for toggle circle
                palette.placeholderText: "#b4b4b4"
                verticalAlignment: Text.AlignVCenter
                background: null
            }

            // <<< ADDED: Ensure password starts hidden when component loads
            Component.onCompleted: {
                passwordField.echoMode = TextInput.Password
                console.log("Initial password visibility: HIDDEN")
            }

            // Circular toggle button
            Rectangle {
                id: togglePasswordVisibility
                width: 30
                height: 19
                color: "transparent"
                radius: 15         // makes it a circle
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 22
                border.color: "black"
                border.width: 0

                Image {
                    id: toggleIconPWL
                    anchors.centerIn: parent
                    width: 30
                    height: 19
                    source: passwordField.echoMode === TextInput.Password
                            ? "qrc:/icons/eyeClosed.svg"
                            : "qrc:/icons/eyeOpen.svg"
                    fillMode: Image.PreserveAspectFit
                    // SVG icon reflects password visibility state
                }


                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (passwordField.echoMode === TextInput.Password) {
                            passwordField.echoMode = TextInput.Normal
                        } else {
                            passwordField.echoMode = TextInput.Password
                        }
                        console.log(
                            "Password visibility:",
                            passwordField.echoMode === TextInput.Password ? "HIDDEN" : "VISIBLE"
                        )
                    }
                }
            }
        }

        // Checkbox images
        Item {
            id: staySignedInButton
            width: 24
            height: 24
            x: 55
            y: 552
            property bool checked: false

            onCheckedChanged: console.log("Stay signed in?:", checked)

            Image {
                id: untickedImage
                source: "qrc:/buttons/staySignedInUnticked.svg"
                visible: !staySignedInButton.checked
                width: 24
                height: 24
                anchors.fill: parent

                MouseArea {
                    anchors.fill: parent
                    onClicked: staySignedInButton.checked = !staySignedInButton.checked
                    cursorShape: Qt.PointingHandCursor
                }
            }

            Image {
                id: tickedImage
                source: "qrc:/buttons/staySignedInTicked.svg"
                visible: staySignedInButton.checked
                width: 24
                height: 24
                anchors.fill: parent

                MouseArea {
                    anchors.fill: parent
                    onClicked: staySignedInButton.checked = !staySignedInButton.checked
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
            anchors.verticalCenter: staySignedInButton.verticalCenter
            x: staySignedInButton.x + staySignedInButton.width + 11
        }

        // Login button
        Item {
            id: loginButton
            width: 66
            height: 66
            anchors.horizontalCenter: parent.horizontalCenter
            y: 650

            property bool hovered: false

            Image {
                id: loginDefault
                anchors.fill: parent
                source: "qrc:/buttons/loginButton.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: loginButton.hovered ? 0 : 1

                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            Image {
                id: loginHover
                anchors.fill: parent
                source: "qrc:/buttons/loginButtonHover.svg"
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: loginButton.hovered ? 1 : 0

                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            HoverHandler { onHoveredChanged: loginButton.hovered = hovered }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    var result = DatabaseManager.validateUserWithStay(usernameField.text, passwordField.text)

                    if (result.locked) {
                        loginErrorText.text = "Maximum attempts exceeded. Account locked"
                        loginErrorText.visible = true
                        console.log("Account locked - cannot login for user:", usernameField.text)
                        return
                    }

                    if (result.success) {
                        loginErrorText.visible = false
                        console.log("Login successful - error message hidden for user:", usernameField.text)
                        DatabaseManager.updateStaySignedIn(usernameField.text, staySignedInButton.checked)
                        console.log("Login successful! Stay signed in:", staySignedInButton.checked)
                        console.log("Failed attempts reset to 0 for user:", usernameField.text)

                        if (loaderRef) {
                            console.log("Switching to home.qml via loaderRef")

                            // Log the actual item being destroyed
                            if (loaderRef.item) {
                                console.log("Unloading login.qml item:", loaderRef.item)
                            }

                            // Load home.qml fresh
                            loaderRef.setSource("home.qml")  // newer QML API ensures proper destruction

                            console.log("home.qml loaded")
                        } else {
                            console.error("loaderRef is not set! Cannot switch to home.qml")
                        }


                    } else {
                        loginErrorText.text = "Invalid username or password"
                        loginErrorText.visible = true
                        console.log("Login failed - error message displayed for user:", usernameField.text)
                        console.log("Failed attempts incremented for user:", usernameField.text)
                    }
                }

            }

        }

        Rectangle {
            id: loginErrorContainer
            width: 500
            height: 177
            anchors.horizontalCenter: parent.horizontalCenter
            y: loginButton.y + loginButton.height + 15

            Text {
                id: loginErrorText
                text: "Invalid username or password"
                visible: false
                color: "#a32e58"
                font.family: "Nexa"
                font.weight: Font.Normal
                font.pointSize: 12
                anchors.centerIn: parent
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

            onClicked: {
                console.log("CREATE ACCOUNT link clicked")
                loginPanel.visible = false
                loginRoot.loaderRef = createAccountLoader   // <-- assign loaderRef
                loginRoot.loaderRef.source = "createAccount.qml"
                loginRoot.loaderRef.visible = true

                // Pass references after the item is fully loaded
                if (loginRoot.loaderRef.item) {
                    loginRoot.loaderRef.item.loginPanelRef = loginPanel
                    loginRoot.loaderRef.item.loaderRef = loginRoot.loaderRef
                    console.log("createAccountPanel references set")
                }
            }



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

    // Loader for Create Account panel
    Loader {
        id: createAccountLoader
        anchors.fill: parent
        source: ""
        visible: false
        z: 2

        property Item loginPanelRef: loginPanel
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
