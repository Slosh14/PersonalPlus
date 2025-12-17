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
    Q_INVOKABLE bool addUser(const QString &username, const QString &password, bool stay_signed_in = false);

    // Updated QML-callable validateUser
    Q_INVOKABLE QVariantMap validateUserWithStay(const QString &username, const QString &password);

private:
    QSqlDatabase m_db;
    QString m_dbPath;
};

#endif // DATABASEMANAGER_H
