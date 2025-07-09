import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: detailsWindow
    width: 700
    height: 500
    visible: true
    title: "Заметка"
    property int day: 0
    property string month: ""
    property int year: 0
    property int monthIndex: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        Text {
            property string modifiedMonth: {
                    if (month === "Март" || month === "Август") {
                        return month.substring(0, month.length) + "а"
                    } else {
                        return month.substring(0, month.length - 1) + "я"
                    }
                }
            text: "Заметка: " + day + " " + modifiedMonth + " " + year
            font.pixelSize: 20
            Layout.alignment: Qt.AlignHCenter
        }
        TextArea {
            id: noteField
            placeholderText: "Введите текст..."
            wrapMode: TextArea.Wrap
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: calendarModel.getNote(year, monthIndex, day)
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Button {
                text: "Save"
                onClicked: {
                    calendarModel.setNote(year, monthIndex, day, noteField.text)
                    detailsWindow.close()
                }
            }
            Button {
                text: "Close"
                onClicked: detailsWindow.close()
            }
        }
    }

    Component.onCompleted: {
        console.log("Loaded note for " + day + " " + month + " " + year + ": " + calendarModel.getNote(year, monthIndex, day))
    }
}
