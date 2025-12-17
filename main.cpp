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

    /* Drop and create tables for testing
    if (!dbManager->dropTables()) {
        qDebug() << "Failed to drop tables!";
    }
    if (!dbManager->createTables()) {
        qDebug() << "Failed to create tables!";
    }*/

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
    QFontDatabase::addApplicationFont(":/fonts/Nexa-Black.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-BlackItalic.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-Bold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-BoldItalic.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-Book.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-BookItalic.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-Heavy.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-HeavyItalic.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-Italic.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-Light.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-LightItalic.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-Regular.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-Thin.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-ThinItalic.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-XBold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Nexa-XBoldItalic.ttf");

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
