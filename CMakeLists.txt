cmake_minimum_required(VERSION 3.16)

project(PersonalPlus VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ✅ CORRECT variable names (yours were broken)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appPersonalPlus
    main.cpp
)

qt_add_qml_module(appPersonalPlus
    URI PersonalPlus

    QML_FILES
        Main.qml
        login.qml

    RESOURCES
        resources/fonts.qrc
        resources/images.qrc
)

set_target_properties(appPersonalPlus PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appPersonalPlus
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appPersonalPlus
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
