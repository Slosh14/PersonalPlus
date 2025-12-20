import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: appRoot
    width: 1920
    height: 1080
    visible: true

    Loader {
        id: mainLoader
        anchors.fill: parent
        source: "login.qml"
    }
}
