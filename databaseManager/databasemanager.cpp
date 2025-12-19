#include "DatabaseManager.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

DatabaseManager::DatabaseManager(const QString &path, QObject *parent)
    : QObject(parent), m_dbPath(path)
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
            stay_signed_in INTEGER DEFAULT 0,
            email TEXT NOT NULL
        )
    )";

    if (!query.exec(createTable)) {
        qDebug() << "Failed to create table:" << query.lastError().text();
        return false;
    }

    qDebug() << "Table 'users' created successfully!";
    return true;
}


bool DatabaseManager::addUser(const QString &username, const QString &password, const QString &email, bool stay_signed_in)
{
    if (!m_db.isOpen()) {
        qDebug() << "Database is not open!";
        return false;
    }

    // Check if username or email already exists
    QSqlQuery checkQuery;
    checkQuery.prepare("SELECT COUNT(*) FROM users WHERE username = :username OR email = :email");
    checkQuery.bindValue(":username", username);
    checkQuery.bindValue(":email", email);

    if (!checkQuery.exec()) {
        qDebug() << "Failed to check for existing user:" << checkQuery.lastError().text();
        return false;
    }

    if (checkQuery.next() && checkQuery.value(0).toInt() > 0) {
        qDebug() << "Username or email already exists!";
        return false;
    }


    QSqlQuery query;
    query.prepare("INSERT INTO users (username, password, email, stay_signed_in) VALUES (:username, :password, :email, :stay_signed_in)");
    query.bindValue(":username", username);
    query.bindValue(":password", password);
    query.bindValue(":email", email);
    query.bindValue(":stay_signed_in", stay_signed_in ? 1 : 0);

    if (!query.exec()) {
        qDebug() << "Failed to add user:" << query.lastError().text();
        return false;
    }

    qDebug() << "User added successfully with email!";
    return true;
}


// QML-callable: returns { success: true/false, staySignedIn: true/false }
QVariantMap DatabaseManager::validateUserWithStay(const QString &username, const QString &password)
{
    QVariantMap result;
    result["success"] = false;
    result["staySignedIn"] = false;

    if (!m_db.isOpen()) {
        qDebug() << "Database is not open!";
        return result;
    }

    QSqlQuery query;
    query.prepare("SELECT stay_signed_in FROM users WHERE username = :username AND password = :password");
    query.bindValue(":username", username);
    query.bindValue(":password", password);

    if (!query.exec()) {
        qDebug() << "Failed to query user:" << query.lastError().text();
        return result;
    }

    if (query.next()) {
        result["success"] = true;
        result["staySignedIn"] = query.value("stay_signed_in").toInt() != 0;
    }

    return result;
}

// QML-callable function to update the 'stay_signed_in' flag for a user
bool DatabaseManager::updateStaySignedIn(const QString &username, bool stay_signed_in)
{
    // Check if the database is open
    if (!m_db.isOpen()) {
        qDebug() << "Database is not open!";
        return false;
    }

    QSqlQuery query;

    // Prepare an UPDATE SQL statement to change stay_signed_in for the given username
    query.prepare("UPDATE users SET stay_signed_in = :stay_signed_in WHERE username = :username");
    query.bindValue(":stay_signed_in", stay_signed_in ? 1 : 0); // Convert bool to integer
    query.bindValue(":username", username); // Bind the username

    // Execute the query
    if (!query.exec()) {
        qDebug() << "Failed to update stay_signed_in:" << query.lastError().text();
        return false;
    }

    qDebug() << "stay_signed_in updated successfully for user:" << username;
    return true; // Return true on success
}

// Return the last user who chose "stay signed in"
QVariantMap DatabaseManager::getLastSignedInUser()
{
    QVariantMap result;
    result["username"] = "";
    result["staySignedIn"] = false;

    if (!m_db.isOpen()) {
        qDebug() << "Database is not open!";
        return result;
    }

    QSqlQuery query;
    query.prepare("SELECT username, stay_signed_in FROM users WHERE stay_signed_in = 1 LIMIT 1");

    if (!query.exec()) {
        qDebug() << "Failed to query last signed-in user:" << query.lastError().text();
        return result;
    }

    if (query.next()) {
        result["username"] = query.value("username").toString();
        result["staySignedIn"] = query.value("stay_signed_in").toInt() != 0;
    }

    return result;
}

