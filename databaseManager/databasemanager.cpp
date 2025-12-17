#include "DatabaseManager.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

DatabaseManager::DatabaseManager(const QString &path)
    : m_dbPath(path)
{
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(m_dbPath);
}

DatabaseManager::~DatabaseManager()
{
    if (m_db.isOpen()) {
        m_db.close();
    }
}

bool DatabaseManager::openDatabase()
{
    if (!m_db.open()) {
        qDebug() << "Failed to open database:" << m_db.lastError().text();
        return false;
    }
    qDebug() << "Database opened successfully!";
    return true;
}

bool DatabaseManager::dropTables()
{
    QSqlQuery query;
    if (!query.exec("DROP TABLE IF EXISTS users")) {
        qDebug() << "Failed to drop table:" << query.lastError().text();
        return false;
    }
    qDebug() << "Table 'users' dropped successfully!";
    return true;
}

bool DatabaseManager::createTables()
{
    QSqlQuery query;
    QString createTable = R"(
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            stay_signed_in INTEGER DEFAULT 0
        )
    )";
    if (!query.exec(createTable)) {
        qDebug() << "Failed to create table:" << query.lastError().text();
        return false;
    }
    qDebug() << "Table 'users' created successfully!";
    return true;
}

bool DatabaseManager::addUser(const QString &username, const QString &password, bool stay_signed_in)
{
    if (!m_db.isOpen()) {
        qDebug() << "Database is not open!";
        return false;
    }

    QSqlQuery query;
    query.prepare("INSERT INTO users (username, password, stay_signed_in) VALUES (:username, :password, :stay_signed_in)");
    query.bindValue(":username", username);
    query.bindValue(":password", password);
    query.bindValue(":stay_signed_in", stay_signed_in ? 1 : 0);

    if (!query.exec()) {
        qDebug() << "Failed to add user:" << query.lastError().text();
        return false;
    }

    qDebug() << "User added successfully!";
    return true;
}
