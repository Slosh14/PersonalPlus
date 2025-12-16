import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: mainWindow
    width: 1920
    height: 1080
    visible: true
    title: qsTr("PersonalPlus")

    // Lock window size completely
    minimumWidth: width
    maximumWidth: width
    minimumHeight: height
    maximumHeight: height

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: "login.qml"
    }
}
