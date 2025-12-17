#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QObject>
#include <QCoreApplication>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QDebug>
#include "databaseManager/DatabaseManager.h"

// Singleton provider function for QML
static QObject* databaseManagerProvider(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    DatabaseManager* dbManager = new DatabaseManager("personalplus.db");
    if (!dbManager->openDatabase()) {
        qDebug() << "Failed to open database!";
    }

    // Drop and create tables for testing
    if (!dbManager->dropTables()) {
        qDebug() << "Failed to drop tables!";
    }
    if (!dbManager->createTables()) {
        qDebug() << "Failed to create tables!";
    }

    // Add test user
    if (!dbManager->addUser("testuser", "password123", false)) {
        qDebug() << "Failed to add test user!";
    } else {
        qDebug() << "Test user added!";
    }

    return dbManager;
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Load fonts
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-black.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-blackitalic.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-bold.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-bolditalic.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-book.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-bookitalic.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-extrabold.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-extrabolditalic.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-extralight.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-extralightitalic.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-heavy.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-heavyitalic.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-light.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-lightitalic.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-regular.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-regularitalic.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-thin.otf");
    QFontDatabase::addApplicationFont(":/fonts/nexa-trial-thinitalic.otf");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    // Register DatabaseManager singleton for QML
    qmlRegisterSingletonType<DatabaseManager>("App.Database", 1, 0, "DatabaseManager", databaseManagerProvider);

    engine.loadFromModule("PersonalPlus", "Main");

    return app.exec();
}
