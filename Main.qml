import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: window
    width: 700
    height: 500
    visible: true
    title: "Calendar"

    // Массив месяцев
    property var months: [
        { name: "Январь", days: 31, year: 2025 },
        { name: "Февраль", days: isLeapYear(2025) ? 29 : 28, year: 2025 },
        { name: "Март", days: 31, year: 2025 },
        { name: "Апрель", days: 30, year: 2025 },
        { name: "Май", days: 31, year: 2025 },
        { name: "Июнь", days: 30, year: 2025 },
        { name: "Июль", days: 31, year: 2025 },
        { name: "Август", days: 31, year: 2025 },
        { name: "Сентябрь", days: 30, year: 2025 },
        { name: "Октябрь", days: 31, year: 2025 },
        { name: "Ноябрь", days: 30, year: 2025 },
        { name: "Декабрь", days: 31, year: 2025 }
    ]

    // Функция для проверки високосного года
    function isLeapYear(year) {
        return (year % 4 === 0 && year % 100 !== 0) || (year % 400 === 0)
    }

    // Текущий выбранный день
    property string selectedDay: ""

    SwipeView {
        id: view
        anchors.fill: parent
        focus: true

        Repeater {
            model: months

            ColumnLayout {
                id: monthPage
                spacing: 10
                property int monthIndex: index
                property string monthName: months[index].name
                property int daysInMonth: months[index].days
                property int year: months[index].year
                // Вычисляем смещение первого дня месяца (0=вс, 1=пн, ..., 6=сб)
                property int firstDayOffset: (new Date(year, monthIndex, 1).getDay() + 6) % 7 // Сдвиг, чтобы понедельник был 0

                Component.onCompleted: {
                    console.log("Month: " + monthName + ", First day offset: " + firstDayOffset)
                }

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
                            // highlighted: text === selectedDay && view.currentIndex === monthPage.monthIndex
                            onClicked: {
                                console.log("Day clicked: " + text + " in " + monthName)
                                selectedDay = text
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
