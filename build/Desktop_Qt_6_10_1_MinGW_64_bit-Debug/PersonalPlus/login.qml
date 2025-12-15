import QtQuick
import QtQuick.Controls

Item {
    id: loginRoot
    width: 1920
    height: 1080

    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    // Test Text using Nexa-Trial font
    Text {
        text: "Sign In"
        font.family: "Nexa-Trial"
        font.pointSize: 50
        font.weight: Font.Bold
        anchors.centerIn: parent
        color: "black"
    }
}
