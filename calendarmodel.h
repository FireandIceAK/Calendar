#ifndef CALENDARMODEL_H
#define CALENDARMODEL_H

#include <QObject>
#include <QDate>
#include <QVariantList>
#include <QSettings>

class CalendarModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(int currentYear READ currentYear WRITE setCurrentYear NOTIFY currentYearChanged)
    Q_PROPERTY(int selectedDay READ selectedDay WRITE setSelectedDay NOTIFY selectedDayChanged)
    Q_PROPERTY(QString selectedMonth READ selectedMonth NOTIFY selectedMonthChanged)

public:
    explicit CalendarModel(QObject *parent = nullptr);

    int currentYear() const { return m_currentYear; }
    void setCurrentYear(int year);

    int selectedDay() const { return m_selectedDay; }
    Q_INVOKABLE void setSelectedDay(int day);

    QString selectedMonth() const { return m_selectedMonth; }

    Q_INVOKABLE QVariantList getMonthData(int monthIndex) const;
    Q_INVOKABLE int getFirstDayOffset(int monthIndex) const;
    Q_INVOKABLE int getDaysInMonth(int monthIndex) const;
    Q_INVOKABLE void setNote(int year, int month, int day, const QString note); // Исправлено ¬e на note
    Q_INVOKABLE QString getNote(int year, int month, int day) const;

signals:
    void currentYearChanged();
    void selectedDayChanged();
    void selectedMonthChanged();
    void noteChanged();

private:
    int m_currentYear;
    int m_selectedDay;
    QString m_selectedMonth;
    QVariantList m_months;
};

#endif // CALENDARMODEL_H
