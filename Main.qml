import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: window
    width: 700
    height: 500
    visible: true
    title: "Календарь"

    property Component detailsWindowComponent: Qt.createComponent("DetailsWindow.qml")

    SwipeView {
        id: view
        anchors.fill: parent
        focus: true

        Repeater {
            model: 12 // Количество месяцев

            ColumnLayout {
                id: monthPage
                spacing: 10
                property int monthIndex: index ?? 0
                property var monthData: calendarModel.getMonthData(index) ?? null
                property string monthName: monthData[0] ?? ""
                property int daysInMonth: monthData[1] ?? 0
                property int year: monthData[2] ?? 0
                property int firstDayOffset: calendarModel.getFirstDayOffset(index) ?? 0

                // Component.onCompleted: {
                //     console.log("Month: " + monthName + ", First day offset: " + firstDayOffset)
                // }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: monthName + " " + year
                    font.pixelSize: 24
                    font.bold: true
                }

                GridLayout {
                    columns: 7
                    rowSpacing: 5
                    columnSpacing: 5
                    Layout.fillWidth: true
                    Repeater {
                        model: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
                        Text {
                            text: modelData
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 16
                            font.bold: true
                        }
                    }
                }

                GridLayout {
                    columns: 7
                    rows: 6
                    rowSpacing: 5
                    columnSpacing: 5
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Repeater {
                        model: 42 // Фиксированная сетка 7x6
                        Button {
                            text: (index < firstDayOffset || index >= daysInMonth + firstDayOffset) ? "" : (index - firstDayOffset + 1)
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            font.pixelSize: 20
                            opacity: text !== "" ? 1 : 0 // Прозрачность для пустых кнопок
                            enabled: text !== ""
                            highlighted: text !== "" && calendarModel.selectedDay === parseInt(text) && view.currentIndex === monthPage.monthIndex

                            onClicked: {
                                console.log("Day clicked: " + text + " in " + monthName)
                                calendarModel.setSelectedDay(parseInt(text))
                                if (detailsWindowComponent.status === Component.Ready) {
                                    var window = detailsWindowComponent.createObject(window, {
                                        day: parseInt(text),
                                        month: monthName,
                                        year: year,
                                        monthIndex: monthPage.monthIndex
                                    })
                                } else {
                                    console.log("Error loading DetailsWindow: " + detailsWindowComponent.errorString())
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    PageIndicator {
        id: indicator
        count: view.count
        currentIndex: view.currentIndex
        anchors.bottom: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
