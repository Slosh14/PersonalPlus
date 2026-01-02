import QtQuick 2.15

Item {
    id: calendarVisualRoot
    width: 300
    height: 309

    property alias visualPanel: calendarVisual
    property var interactiveElements: []
    property var selectedDayItem: null      // Track which day cell is currently selected (visual only)
    property var selectedDayText: null      // Track the selected day's Text item (visual only)

    // Calendar state that drives the grid (month is 0-based)
    property int displayMonth: 8            // September
    property int displayYear: 2025

    // Stores selection per month/year (key: "YYYY-MM" -> dayNumber)
    property var selectedByMonthYear: ({})  // Brief comment: remembers selections per month/year

    function monthKey(year, monthIndex) {
        // Brief comment: stable key for selection storage (monthIndex is 0-based)
        var mm = (monthIndex + 1).toString()
        if (mm.length === 1) mm = "0" + mm
        return year.toString() + "-" + mm
    }

    function registerInteractiveElement(element) {
        if (interactiveElements.indexOf(element) === -1) {
            interactiveElements.push(element)
            console.log("Registered interactive element:", element)
        }
    }

    function closeInteractions(preserve) {
        for (var i = 0; i < interactiveElements.length; i++) {
            var element = interactiveElements[i]
            if (element !== preserve) {
                element.visible = false
            }
        }
        console.log("Visual panel interactions closed (preserve:", preserve, ")")
    }

    function activatePanel(preserveDropdown) {
        calendarVisual.active = true
        console.log("Panel activated: calendarVisual.active =", calendarVisual.active)

        closeInteractions(preserveDropdown)

        if (calendarRoot.optionsLoader.item && calendarRoot.optionsLoader.item.optionsPanel) {
            calendarRoot.optionsLoader.item.optionsPanel.active = false
            calendarRoot.optionsLoader.item.closeInteractions()
        }
        if (calendarRoot.mainLoader.item && calendarRoot.mainLoader.item.mainPanel) {
            calendarRoot.mainLoader.item.mainPanel.active = false
            calendarRoot.mainLoader.item.closeInteractions()
        }
    }

    function clearSelectedDayVisual() {
        // Brief comment: clears ONLY the visual active box
        if (selectedDayText && selectedDayItem) {
            selectedDayText.color = selectedDayItem.isCurrentMonth ? "#ffffff" : "#888888"
        }
        selectedDayItem = null
        selectedDayText = null
        console.log("Visual selection cleared (month/year changed)") // Test log
    }

    function rememberSelectionForCurrentMonth(dayNum) {
        // Brief comment: store selected day for current display month/year (overwrites existing)
        var key = monthKey(displayYear, displayMonth)
        selectedByMonthYear[key] = dayNum
        console.log("Selection saved:", key, "->", dayNum) // Test log
    }

    function getRememberedSelectionForCurrentMonth() {
        // Brief comment: fetch stored selection for current display month/year (or undefined)
        var key = monthKey(displayYear, displayMonth)
        return selectedByMonthYear[key]
    }

    function clearAllRememberedSelectionsExceptCurrent() {
        // Brief comment: ensures ONLY ONE remembered selection exists globally (except today underline)
        var keepKey = monthKey(displayYear, displayMonth)
        var keepVal = selectedByMonthYear[keepKey]

        selectedByMonthYear = ({})
        if (keepVal !== undefined) {
            selectedByMonthYear[keepKey] = keepVal
        }

        console.log("Selection map reset. Kept:", keepKey, "->", keepVal) // Test log
    }

    function syncDisplayFromHeader() {
        // Brief comment: sync displayMonth/displayYear from monthText/yearText (test log included)
        var months = monthDropdown.model
        var idx = months.indexOf(monthText.text)
        if (idx === -1) {
            idx = 0
        }

        displayMonth = idx
        displayYear = parseInt(yearText.text, 10)

        console.log("Calendar display synced from header -> MonthIndex:", displayMonth, "Year:", displayYear)
    }

    function applyHeaderFromDisplay() {
        // Brief comment: apply displayMonth/displayYear onto header (test log included)
        monthText.text = monthDropdown.model[displayMonth]
        yearText.text = displayYear.toString()

        console.log("Calendar header applied from display ->", monthText.text, yearText.text)
    }

    function setDisplayToToday() {
        // Brief comment: initialize calendar to current month/year on load (test log included)
        var today = new Date()
        displayMonth = today.getMonth()
        displayYear = today.getFullYear()

        applyHeaderFromDisplay()
        clearSelectedDayVisual()

        console.log("Calendar set to today on load -> MonthIndex:", displayMonth, "Year:", displayYear) // Test log
    }

    function goToNextMonth() {
        // Brief comment: advance month text (wrap + bump year), then sync + clear visual selection
        var months = monthDropdown.model
        var currentIndex = months.indexOf(monthText.text)
        if (currentIndex === -1) {
            currentIndex = 0
        }

        var nextIndex = currentIndex + 1
        if (nextIndex >= months.length) {
            nextIndex = 0
            yearText.text = (parseInt(yearText.text, 10) + 1).toString()
        }

        monthText.text = months[nextIndex]
        console.log("Next month applied:", monthText.text, "Year:", yearText.text) // Test log

        clearSelectedDayVisual()
        syncDisplayFromHeader()
    }

    function goToPrevMonth() {
        // Brief comment: go back a month text (wrap + lower year), then sync + clear visual selection
        var months = monthDropdown.model
        var currentIndex = months.indexOf(monthText.text)
        if (currentIndex === -1) {
            currentIndex = 0
        }

        var prevIndex = currentIndex - 1
        if (prevIndex < 0) {
            prevIndex = months.length - 1
            yearText.text = (parseInt(yearText.text, 10) - 1).toString()
        }

        monthText.text = months[prevIndex]
        console.log("Previous month applied:", monthText.text, "Year:", yearText.text) // Test log

        clearSelectedDayVisual()
        syncDisplayFromHeader()
    }

    Rectangle {
        id: calendarVisual
        anchors.fill: parent
        color: "#172837"
        radius: 5
        border.width: 1
        property bool active: false
        border.color: active ? "#2ca890" : "#485059"

        Rectangle {
            anchors.fill: parent
            anchors.margins: 20
            color: "#172837"
            radius: 5
        }

        MouseArea {
            anchors.fill: parent
            onClicked: activatePanel(null)
        }

        Item {
            anchors.fill: parent
            anchors.margins: 20

            // ✅ Updated header layout: arrows fixed 10px from left/right edges
            Item {
                id: monthYearRow
                width: parent.width
                height: Math.max(16, monthText.implicitHeight + 6) // Brief comment: keep header tall enough for text
                anchors.top: parent.top

                // LEFT UP ARROW (fixed 10px from left edge)
                Item {
                    width: 16
                    height: 16
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        id: upArrowButton
                        source: "buttons/upArrowUnClicked.svg"
                        width: 16
                        height: 16
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: upArrowButton.source = "buttons/upArrowHover.svg"
                            onExited: upArrowButton.source = "buttons/upArrowUnClicked.svg"
                            onClicked: {
                                console.log("Up arrow clicked")
                                upArrowButton.source = "buttons/upArrowClicked.svg"
                                goToPrevMonth()
                                activatePanel(null)
                                upArrowClickTimer.start()
                            }
                        }

                        Timer {
                            id: upArrowClickTimer
                            interval: 100
                            repeat: false
                            onTriggered: {
                                upArrowButton.source = "buttons/upArrowUnClicked.svg"
                                console.log("Up arrow reverted to unclicked state")
                            }
                        }
                    }
                }

                // RIGHT DOWN ARROW (fixed 10px from right edge)
                Item {
                    width: 16
                    height: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        id: downArrowButton
                        source: "buttons/downArrowUnClicked.svg"
                        width: 16
                        height: 16
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: downArrowButton.source = "buttons/downArrowHover.svg"
                            onExited: downArrowButton.source = "buttons/downArrowUnClicked.svg"
                            onClicked: {
                                console.log("Down arrow clicked")
                                downArrowButton.source = "buttons/downArrowClicked.svg"
                                goToNextMonth()
                                activatePanel(null)
                                downArrowClickTimer.start()
                            }
                        }

                        Timer {
                            id: downArrowClickTimer
                            interval: 100
                            repeat: false
                            onTriggered: {
                                downArrowButton.source = "buttons/downArrowUnClicked.svg"
                                console.log("Down arrow reverted to unclicked state")
                            }
                        }
                    }
                }

                // CENTERED MONTH/YEAR GROUP
                Row {
                    anchors.centerIn: parent
                    spacing: 0

                    Item { width: 8; height: monthText.implicitHeight + 6 }

                    Item {
                        width: monthText.implicitWidth
                        height: monthText.implicitHeight + 6
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            id: monthBox
                            anchors.fill: parent
                            color: "#172837"
                            radius: 4

                            Text {
                                id: monthText
                                text: "September"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                font.family: "Nexa"
                                font.weight: Font.Bold
                                font.pointSize: 14
                                color: "#f0f0f0"
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: monthText.color = "#d2d2d2"
                                onExited: monthText.color = "#f0f0f0"
                                onClicked: {
                                    monthDropdown.x = monthBox.mapToItem(calendarVisual, 0, 0).x
                                    monthDropdown.y = monthBox.mapToItem(calendarVisual, 0, monthBox.height).y
                                    monthDropdown.visible = !monthDropdown.visible
                                    activatePanel(monthDropdown)
                                }
                            }
                        }

                        Component.onCompleted: registerInteractiveElement(monthDropdown)
                    }

                    Item {
                        width: 8
                        height: 16
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text: ","
                            anchors.centerIn: parent
                            font.family: "Nexa"
                            font.weight: Font.Bold
                            font.pointSize: 14
                            color: "#f0f0f0"
                        }
                    }

                    Item { width: 8; height: 1 }

                    Item {
                        width: yearText.implicitWidth
                        height: yearText.implicitHeight + 6
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            id: yearBox
                            anchors.fill: parent
                            color: "#172837"
                            radius: 4

                            Text {
                                id: yearText
                                text: "2025"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: "Nexa"
                                font.weight: Font.Bold
                                font.pointSize: 14
                                color: "#f0f0f0"
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: yearText.color = "#d2d2d2"
                                onExited: yearText.color = "#f0f0f0"
                                onClicked: {
                                    yearDropdown.x = yearBox.mapToItem(calendarVisual, 0, 0).x
                                    yearDropdown.y = yearBox.mapToItem(calendarVisual, 0, yearBox.height).y
                                    yearDropdown.visible = !yearDropdown.visible
                                    activatePanel(yearDropdown)
                                }
                            }
                        }

                        Component.onCompleted: registerInteractiveElement(yearDropdown)
                    }

                    Item { width: 8; height: yearText.implicitHeight + 6 }
                }
            }

            Column {
                anchors.top: monthYearRow.bottom
                anchors.topMargin: 18
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 13

                Row {
                    id: dayLabelsRow
                    spacing: 13
                    anchors.horizontalCenter: parent.horizontalCenter
                    bottomPadding: 5

                    Repeater {
                        model: ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
                        Rectangle {
                            width: 25
                            height: 25
                            color: "#172837"
                            radius: 3

                            Text {
                                text: modelData
                                anchors.centerIn: parent
                                font.family: "Nexa"
                                font.weight: Font.Bold
                                font.pixelSize: 10
                                color: "#757678"
                            }
                        }
                    }
                }

                Repeater {
                    model: 5
                    Row {
                        property int rowIndex: index
                        spacing: 13

                        Repeater {
                            model: 7
                            Rectangle {
                                id: dayCell
                                width: 25
                                height: 25
                                color: "#172837"
                                radius: 3

                                property int cellIndex: -1
                                property int dayNumber: 0
                                property bool isCurrentMonth: false

                                Item {
                                    anchors.fill: parent

                                    Text {
                                        id: dayText
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: "#f0f0f0"
                                        font.family: "Nexa"
                                        font.weight: Font.Bold
                                        font.pixelSize: 15
                                    }

                                    Rectangle {
                                        id: todayUnderline
                                        anchors.top: dayText.bottom
                                        anchors.horizontalCenter: dayText.horizontalCenter
                                        width: 25
                                        height: 3
                                        radius: 1
                                        color: "#28a0ae"
                                        visible: false
                                    }
                                }

                                function updateFromDisplay() {
                                    // Brief comment: recompute cell for active month/year and restore remembered selection
                                    var year = calendarVisualRoot.displayYear
                                    var month = calendarVisualRoot.displayMonth

                                    var today = new Date()
                                    var firstDay = (new Date(year, month, 1).getDay() + 6) % 7
                                    var daysInMonth = new Date(year, month + 1, 0).getDate()
                                    var daysInPrevMonth = new Date(year, month, 0).getDate()

                                    cellIndex = index + (rowIndex * 7)
                                    var dayNum = 0

                                    todayUnderline.visible = false

                                    if (cellIndex < firstDay) {
                                        dayNum = daysInPrevMonth - firstDay + cellIndex + 1
                                        dayText.color = "#888888"
                                        isCurrentMonth = false
                                    } else if (cellIndex >= firstDay + daysInMonth) {
                                        dayNum = cellIndex - firstDay - daysInMonth + 1
                                        dayText.color = "#888888"
                                        isCurrentMonth = false
                                    } else {
                                        dayNum = cellIndex - firstDay + 1
                                        dayText.color = "#ffffff"
                                        isCurrentMonth = true

                                        if (dayNum === today.getDate() &&
                                                month === today.getMonth() &&
                                                year === today.getFullYear()) {
                                            todayUnderline.visible = true
                                        }
                                    }

                                    dayText.text = dayNum
                                    dayNumber = dayNum

                                    var remembered = calendarVisualRoot.getRememberedSelectionForCurrentMonth()
                                    if (isCurrentMonth && remembered !== undefined && dayNumber === remembered) {
                                        calendarVisualRoot.selectedDayItem = dayCell
                                        calendarVisualRoot.selectedDayText = dayText
                                        dayText.color = "#28a0ae"
                                        console.log("Selection restored for", calendarVisualRoot.monthKey(year, month), "->", remembered) // Test log
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor

                                    onEntered: {
                                        if (calendarVisualRoot.selectedDayItem !== dayCell) {
                                            dayText.color = "#d2d2d2"
                                        }
                                    }

                                    onExited: {
                                        if (calendarVisualRoot.selectedDayItem === dayCell) {
                                            dayText.color = "#28a0ae"
                                        } else {
                                            dayText.color = dayCell.isCurrentMonth ? "#ffffff" : "#888888"
                                        }
                                    }

                                    onClicked: {
                                        if (!dayCell.isCurrentMonth) {
                                            console.log("Ignored click: not current month day ->", dayCell.dayNumber) // Test log
                                            return
                                        }

                                        if (calendarVisualRoot.selectedDayText && calendarVisualRoot.selectedDayItem) {
                                            calendarVisualRoot.selectedDayText.color =
                                                calendarVisualRoot.selectedDayItem.isCurrentMonth ? "#ffffff" : "#888888"
                                        }

                                        calendarVisualRoot.selectedDayItem = dayCell
                                        calendarVisualRoot.selectedDayText = dayText
                                        dayText.color = "#28a0ae"

                                        calendarVisualRoot.clearAllRememberedSelectionsExceptCurrent()
                                        calendarVisualRoot.rememberSelectionForCurrentMonth(dayCell.dayNumber)

                                        activatePanel(null)
                                    }
                                }

                                Component.onCompleted: {
                                    updateFromDisplay()
                                }

                                Connections {
                                    target: calendarVisualRoot
                                    function onDisplayMonthChanged() { updateFromDisplay() }
                                    function onDisplayYearChanged() { updateFromDisplay() }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    ListView {
        id: monthDropdown
        width: 110
        height: 240
        clip: true
        visible: false
        model: ["January","February","March","April","May","June","July","August","September","October","November","December"]
        boundsBehavior: Flickable.StopAtBounds

        delegate: Rectangle {
            width: parent.width
            height: 30
            color: "#f0f0f0"

            Text {
                text: modelData
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 8
                color: "#4b4b4b"
                font.family: "Nexa"
                font.weight: Font.Light
                font.pointSize: 12
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = "#d0d0d0"
                onExited: parent.color = "#f0f0f0"
                onClicked: {
                    monthText.text = modelData
                    monthDropdown.visible = false
                    console.log("Month selected:", modelData)
                    activatePanel(null)

                    clearSelectedDayVisual()
                    syncDisplayFromHeader()
                }
            }
        }
    }

    ListView {
        id: yearDropdown
        width: 60
        height: 120
        clip: true
        visible: false
        model: [2020,2021,2022,2023,2024,2025,2026,2027,2028,2029,2030]
        boundsBehavior: Flickable.StopAtBounds

        delegate: Rectangle {
            width: parent.width
            height: 30
            color: "#f0f0f0"

            Text {
                text: modelData
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 8
                color: "#4b4b4b"
                font.family: "Nexa"
                font.weight: Font.Light
                font.pointSize: 12
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = "#d0d0d0"
                onExited: parent.color = "#f0f0f0"
                onClicked: {
                    yearText.text = modelData
                    yearDropdown.visible = false
                    console.log("Year selected:", modelData)
                    activatePanel(null)

                    clearSelectedDayVisual()
                    syncDisplayFromHeader()
                }
            }
        }
    }

    Component.onCompleted: {
        // Brief comment: start on the real current month/year instead of the hardcoded defaults
        setDisplayToToday()
        console.log("Calendar initialized to current month/year:", monthText.text, yearText.text) // Test log

        // Brief comment: spacing test log so you can confirm the header moved down
        console.log("Header Y position (should be lower):", monthYearRow.y) // Test log
    }

    Component.onDestruction: {
        console.log("CalendarVisual.qml destroyed:", calendarVisualRoot)
    }
}
