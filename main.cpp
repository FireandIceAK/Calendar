#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QIcon>
#include "calendarmodel.h"

int main(int argc, char *argv[])
{
    // qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon("D:/Project/calendar/Calendar/images/pngwing.com.png"));

    QSettings settings("MySoft", "Calendar");

    QQmlApplicationEngine engine;
    CalendarModel calendarModel;
    engine.rootContext()->setContextProperty("calendarModel", &calendarModel);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("calendar", "Main");

    return app.exec();
}
