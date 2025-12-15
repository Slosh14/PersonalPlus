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

    Image {
        id: loginBackground
        source: "qrc:/images/loginBackground.jpg"
        x: 540
        y: 0
        width: 1380
        height: 1080
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
