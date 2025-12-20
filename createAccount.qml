import QtQuick 2.15
import QtQuick.Controls 2.15
import App.Database 1.0

Item {
    id: createAccountPanel
    width: 540
    height: 1080
    x: 0
    y: 0
    z: 1

    function validatePassword(password) {
        console.log("Validating password")

        // Length check
        if (password.length < 12 || password.length > 128) {
            createAccountErrorText.text = "Password must be between 12–128 characters"
            return false
        }

        // Complexity checks
        let uppercase = /[A-Z]/.test(password)
        let lowercase = /[a-z]/.test(password)
        let number = /[0-9]/.test(password)
        let specialChar = /[!@#$%^&*(),.?\":{}|<>]/.test(password)

        if (!uppercase || !lowercase) {
            createAccountErrorText.text = "Password requires both\nuppercase and lowercase letters"
            return false
        }
        if (!number || !specialChar) {
            createAccountErrorText.text = "Password requires at least\none number and one special character"
            return false
        }

        // Sequential chars (3 in a row)
        let seq = "abcdefghijklmnopqrstuvwxyz0123456789"
        let lowerPassword = password.toLowerCase()
        let hasSequential = false
        for (let j = 0; j <= lowerPassword.length - 3; j++) {
            if (seq.includes(lowerPassword.substr(j, 3))) {
                hasSequential = true
                break
            }
        }

        // Repeated chars (3 consecutive)
        let hasRepeated = false
        for (let k = 0; k <= password.length - 3; k++) {
            if (password[k] === password[k + 1] && password[k] === password[k + 2]) {
                hasRepeated = true
                break
            }
        }

        if (hasSequential || hasRepeated) {
            createAccountErrorText.text = "Password fails complexity\ncontains sequential or repeated characters"
            return false
        }

        createAccountErrorText.text = ""  // clear previous error if password is valid
        console.log("Password OK")
        return true
    }

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
                rightPadding: 65
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
                rightPadding: 65
                palette.placeholderText: "#b4b4b4"
                verticalAlignment: Text.AlignVCenter
                background: null
            }

            Component.onCompleted: {
                createPasswordField.echoMode = TextInput.Password
            }

            // Circular toggle button
            Rectangle {
                id: toggleCreatePasswordVisibility
                width: 30
                height: 19
                color: "transparent"
                radius: 15
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 22

                Image {
                    id: toggleIconCPW
                    anchors.centerIn: parent
                    width: 30
                    height: 19
                    source: createPasswordField.echoMode === TextInput.Password
                            ? "qrc:/icons/eyeClosed.svg"
                            : "qrc:/icons/eyeOpen.svg"
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        createPasswordField.echoMode = createPasswordField.echoMode === TextInput.Password
                            ? TextInput.Normal
                            : TextInput.Password
                        console.log("Password visibility:", createPasswordField.echoMode === TextInput.Password ? "HIDDEN" : "VISIBLE")
                    }
                }
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

        // Confirm Password Field
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
                rightPadding: 65
                palette.placeholderText: "#b4b4b4"
                verticalAlignment: Text.AlignVCenter
                background: null
            }

            Component.onCompleted: {
                confirmPasswordField.echoMode = TextInput.Password
            }

            Rectangle {
                id: toggleConfirmPasswordVisibility
                width: 30
                height: 19
                color: "transparent"
                radius: 15
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 22

                Image {
                    id: toggleIconCNFPW
                    anchors.centerIn: parent
                    width: 30
                    height: 19
                    source: confirmPasswordField.echoMode === TextInput.Password
                            ? "qrc:/icons/eyeClosed.svg"
                            : "qrc:/icons/eyeOpen.svg"
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        confirmPasswordField.echoMode = confirmPasswordField.echoMode === TextInput.Password
                            ? TextInput.Normal
                            : TextInput.Password
                        console.log("Password visibility:", confirmPasswordField.echoMode === TextInput.Password ? "HIDDEN" : "VISIBLE")
                    }
                }
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
                rightPadding: 65
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
                    var confirm = confirmPasswordField.text
                    var email = enterEmailAddressField.text

                    createAccountErrorText.text = ""  // clear previous errors

                    if (!username || !password || !confirm || !email) {
                        createAccountErrorText.text = "Fill all fields"
                        console.log("Fill all fields")
                        return
                    }

                    function validateEmail(email) {
                        var tlds = ["com","org","net","edu","gov","mil","int","info","biz","io","co","us","uk","ca","de","fr","jp","au","cn","ru","br","in","xyz","online","tech","site","store","blog","app"];
                        var re = new RegExp("^[^\\s@]+@[^\\s@]+\\.(" + tlds.join("|") + ")$", "i");
                        if (!re.test(email)) {
                            createAccountErrorText.text = "Email invalid"
                            console.log("Email invalid")
                            return false
                        }
                        return true
                    }

                    if (!validateEmail(email)) return

                    if (password !== confirm) {
                        createAccountErrorText.text = "Passwords do not match"
                        console.log("Passwords do not match")
                        return
                    }

                    if (!validatePassword(password)) {
                        console.log("Password invalid")
                        return
                    }

                    var success = DatabaseManager.addUser(username, password, email, false)
                    console.log(success ? "User created" : "Signup failed")
                    if (success) {
                        loaderRef.source = ""
                        loginPanelRef.visible = true
                    }
                }
            }
        }

        // Error message container for Create Account
        Rectangle {
            id: createAccountErrorContainer
            width: 500
            height: 130
            anchors.horizontalCenter: parent.horizontalCenter
            y: signUpButton.y + signUpButton.height + 11

            Text {
                id: createAccountErrorText
                text: ""              // dynamically set when validation fails
                visible: true
                color: "#a32e58"     // red/pink error color
                font.family: "Nexa"
                font.weight: Font.Normal
                font.pointSize: 12
                wrapMode: Text.NoWrap
                horizontalAlignment: Text.AlignHCenter
                anchors.centerIn: parent
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
