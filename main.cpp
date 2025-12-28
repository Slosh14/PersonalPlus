#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFontDatabase>
#include <QObject>
#include <QCoreApplication>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QDebug>
#include "databaseManager/DatabaseManager.h"
#include <QIcon>

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
    }*/

    if (!dbManager->createTables()) {
        qDebug() << "Failed to create tables!";
    }

    // Add test user with email
    if (!dbManager->addUser("testuser", "password123", "testuser@example.com", false)) {
        qDebug() << "Failed to add test user!";
    } else {
        qDebug() << "Test user added with email!";
    }

    return dbManager;
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("Personal Plus");
    app.setWindowIcon(QIcon(":/icons/logoIcon256.ico"));

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

    // Use the singleton instance to check last signed-in user
    QObject* dbManagerObj = databaseManagerProvider(nullptr, nullptr);
    DatabaseManager* dbManager = qobject_cast<DatabaseManager*>(dbManagerObj);

    QString autoLoginUsername;
    bool staySignedIn = false;

    if (dbManager && dbManager->openDatabase()) {
        QVariantMap lastUser = dbManager->getLastSignedInUser();
        if (!lastUser["username"].toString().isEmpty() && lastUser["staySignedIn"].toBool()) {
            autoLoginUsername = lastUser["username"].toString();
            staySignedIn = true;
            qDebug() << "Auto-login user detected:" << autoLoginUsername;
        } else {
            qDebug() << "No auto-login user found";
        }
    } else {
        qDebug() << "Failed to open database for auto-login check";
    }

    // Expose the auto-login info to QML
    engine.rootContext()->setContextProperty("autoLoginUsername", autoLoginUsername);
    engine.rootContext()->setContextProperty("autoLoginStaySignedIn", staySignedIn);

    // Load AppRoot.qml as normal (ApplicationWindow ensures visible window)
    engine.load(QUrl(QStringLiteral("qrc:/AppRoot.qml")));
    qDebug() << "Loaded QML: qrc:/AppRoot.qml";

    return app.exec();
}
