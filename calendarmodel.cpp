#include "calendarmodel.h"

CalendarModel::CalendarModel(QObject *parent) : QObject(parent),
    m_currentYear(2025), m_selectedDay(0), m_selectedMonth("")
{
    m_months = {
        QVariantMap{{"name", "Январь"}, {"days", 31}, {"year", 2025}},
        QVariantMap{{"name", "Февраль"}, {"days", QDate(2025, 2, 1).daysInMonth()}, {"year", 2025}},
        QVariantMap{{"name", "Март"}, {"days", 31}, {"year", 2025}},
        QVariantMap{{"name", "Апрель"}, {"days", 30}, {"year", 2025}},
        QVariantMap{{"name", "Май"}, {"days", 31}, {"year", 2025}},
        QVariantMap{{"name", "Июнь"}, {"days", 30}, {"year", 2025}},
        QVariantMap{{"name", "Июль"}, {"days", 31}, {"year", 2025}},
        QVariantMap{{"name", "Август"}, {"days", 31}, {"year", 2025}},
        QVariantMap{{"name", "Сентябрь"}, {"days", 30}, {"year", 2025}},
        QVariantMap{{"name", "Октябрь"}, {"days", 31}, {"year", 2025}},
        QVariantMap{{"name", "Ноябрь"}, {"days", 30}, {"year", 2025}},
        QVariantMap{{"name", "Декабрь"}, {"days", 31}, {"year", 2025}}
    };
}

void CalendarModel::setCurrentYear(int year) {
    if (m_currentYear != year) {
        m_currentYear = year;
        QVariantMap febMap = m_months[1].toMap();
        febMap["days"] = QDate(year, 2, 1).daysInMonth();
        m_months[1] = febMap;
        emit currentYearChanged();
    }
}

void CalendarModel::setSelectedDay(int day) {
    if (m_selectedDay != day) {
        m_selectedDay = day;
        emit selectedDayChanged();
    }
}

QVariantList CalendarModel::getMonthData(int monthIndex) const {
    if (monthIndex >= 0 && monthIndex < m_months.size()) {
        QVariantMap monthMap = m_months[monthIndex].toMap();
        return { monthMap["name"], monthMap["days"], monthMap["year"] };
    }
    return {};
}

int CalendarModel::getFirstDayOffset(int monthIndex) const {
    if (monthIndex >= 0 && monthIndex < m_months.size()) {
        QDate firstDay(m_currentYear, monthIndex + 1, 1);
        return (firstDay.dayOfWeek() + 6) % 7; // Исправлено для правильного отображения дней недели
    }
    return 0;
}

int CalendarModel::getDaysInMonth(int monthIndex) const {
    if (monthIndex >= 0 && monthIndex < m_months.size()) {
        return m_months[monthIndex].toMap()["days"].toInt();
    }
    return 30;
}

void CalendarModel::setNote(int year, int month, int day, const QString note) {
    QString key = QString("notes/%1-%2-%3").arg(year).arg(month + 1, 2, 10, QChar('0')).arg(day, 2, 10, QChar('0'));
    QSettings settings("MySoft", "Calendar");
    if (note.isEmpty()) {
        settings.remove(key);
    } else {
        settings.setValue(key, note);
    }
    qDebug() << "Saving note for" << key << ":" << note;
    emit noteChanged();
}

QString CalendarModel::getNote(int year, int month, int day) const {
    QString key = QString("notes/%1-%2-%3").arg(year).arg(month + 1, 2, 10, QChar('0')).arg(day, 2, 10, QChar('0'));
    QSettings settings("MySoft", "Calendar");
    return settings.value(key, "").toString();
}
