import QtQuick 2.15

Item {
    id: calendarRoot
    width: 1800       // match Loader width
    height: 1080      // match Loader height

    Rectangle {
        id: calendarVisual
        x: 124
        y: 4
        width: 300
        height: 309
        color: "#172837"
        radius: 5
        border.width: 1
        property bool active: false
        border.color: active ? "#2ca890" : "#485059"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                calendarVisual.active = true
                calendarOptions.active = false
                calendarMain.active = false
                console.log("calendarVisual panel selected")
            }
        }
    }

    Rectangle {
        id: calendarOptions
        x: 124
        y: 317
        width: 300
        height: 759
        color: "#172837"
        radius: 5
        border.width: 1
        property bool active: false
        border.color: active ? "#2ca890" : "#485059"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                calendarVisual.active = false
                calendarOptions.active = true
                calendarMain.active = false
                console.log("calendarOptions panel selected")
            }
        }
    }

    Rectangle {
        id: calendarMain
        x: 428
        y: 4
        width: 1488
        height: 1072
        color: "#172837"
        radius: 5
        border.width: 1
        property bool active: false
        border.color: active ? "#2ca890" : "#485059"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                calendarVisual.active = false
                calendarOptions.active = false
                calendarMain.active = true
                console.log("calendarMain panel selected")
            }
        }
    }

    Component.onDestruction: {
        console.log("Calendar.qml destroyed:", calendarRoot)
    }
}
