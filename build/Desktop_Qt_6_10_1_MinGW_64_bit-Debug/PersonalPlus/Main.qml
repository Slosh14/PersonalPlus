import QtQuick
import QtQuick.Controls 2.15

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Personal Plus")

    Text {
        text: "Sign In"
        font.family: "Nexa-Trial"
        font.pointSize: 24
        font.weight: Font.Black       // For Bold variant
        anchors.centerIn: parent
    }

}
