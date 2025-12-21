#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QSqlDatabase>
#include <QString>
#include <QObject>
#include <QVariantMap> // For QML-friendly return

class DatabaseManager : public QObject
{
    Q_OBJECT

public:
    explicit DatabaseManager(const QString &path, QObject *parent = nullptr);
    ~DatabaseManager();

    Q_INVOKABLE bool openDatabase();
    Q_INVOKABLE bool dropTables();
    Q_INVOKABLE bool createTables();
    Q_INVOKABLE bool addUser(const QString &username, const QString &password, const QString &email, bool stay_signed_in = false);

    // Updated QML-callable validateUser
    Q_INVOKABLE QVariantMap validateUserWithStay(const QString &username, const QString &password);

    // Updates sign in field
    Q_INVOKABLE bool updateStaySignedIn(const QString &username, bool stay_signed_in);

    // Updates currently_signed_in status for a user
    Q_INVOKABLE bool setCurrentlySignedIn(const QString &username, bool currentlySignedIn);

    // Returns the username of the currently signed-in user, or empty string if none
    Q_INVOKABLE QString getCurrentlySignedInUser();

    // Get the last signed-in user
    Q_INVOKABLE QVariantMap getLastSignedInUser();

    // Add this inside the DatabaseManager class, under public:
    Q_INVOKABLE bool signOutUser(const QString &username);


private:
    QSqlDatabase m_db;
    QString m_dbPath;
};

#endif // DATABASEMANAGER_H
