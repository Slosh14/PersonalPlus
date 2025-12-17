#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QSqlDatabase>
#include <QString>

class DatabaseManager
{
public:
    explicit DatabaseManager(const QString &path);
    ~DatabaseManager();

    bool openDatabase();
    bool dropTables(); // <--- added this
    bool createTables();
    bool addUser(const QString &username, const QString &password, bool stay_signed_in = false);

private:
    QSqlDatabase m_db;
    QString m_dbPath;
};

#endif // DATABASEMANAGER_H
