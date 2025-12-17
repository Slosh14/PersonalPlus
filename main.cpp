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

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    DatabaseManager dbManager("personalplus.db");

    if (dbManager.openDatabase()) {
        qDebug() << "DatabaseManager: Database opened successfully!";
    } else {
        qDebug() << "DatabaseManager: Failed to open database!";
    }

    // Drop tables first to start fresh for testing
    if (dbManager.dropTables()) {
        qDebug() << "DatabaseManager: Tables dropped successfully!";
    } else {
        qDebug() << "DatabaseManager: Failed to drop tables!";
    }

    if (dbManager.createTables()) {
        qDebug() << "DatabaseManager: Table 'users' created successfully!";
    } else {
        qDebug() << "DatabaseManager: Failed to create table!";
    }

    if (dbManager.addUser("testuser", "password123", false)) {
        qDebug() << "Test user added!";
    } else {
        qDebug() << "Failed to add test user!";
    }

    // Load all Nexa-Trial fonts from the .qrc resource
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

    engine.loadFromModule("PersonalPlus", "Main");

    return app.exec();
}
