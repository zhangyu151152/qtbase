# Generated from part6.pro.

cmake_minimum_required(VERSION 3.14)
project(part6 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(INSTALL_EXAMPLEDIR "examples/widgets/tutorials/addressbook/part6")

find_package(Qt6 COMPONENTS Core)
find_package(Qt6 COMPONENTS Gui)
find_package(Qt6 COMPONENTS Widgets)

add_qt_gui_executable(part6
    addressbook.cpp addressbook.h
    finddialog.cpp finddialog.h
    main.cpp
)
target_link_libraries(part6 PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Widgets
)

install(TARGETS part6
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)
