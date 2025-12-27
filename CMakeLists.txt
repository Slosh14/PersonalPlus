cmake_minimum_required(VERSION 3.16)

project(PersonalPlus VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ✅ Enable Qt features
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appPersonalPlus
    main.cpp
)

qt_add_qml_module(appPersonalPlus
    URI PersonalPlus

    QML_FILES

    Login.qml

    RESOURCES
        resources/fonts.qrc
        RESOURCES resources/images.qrc
        RESOURCES resources/buttons.qrc
        SOURCES databaseManager/databasemanager.h databaseManager/databasemanager.cpp
        QML_FILES CreateAccount.qml
        RESOURCES resources/icons.qrc
        QML_FILES AppRoot.qml
        RESOURCES qml.qrc
        QML_FILES Home.qml
        QML_FILES NavBar.qml
        QML_FILES Calendar.qml
        QML_FILES CalendarVisual.qml
        QML_FILES CalendarOptions.qml
        QML_FILES CalendarMain.qml

)

set_target_properties(appPersonalPlus PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appPersonalPlus
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Sql
)

include(GNUInstallDirs)
install(TARGETS appPersonalPlus
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
