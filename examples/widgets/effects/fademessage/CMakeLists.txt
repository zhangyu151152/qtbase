# Generated from fademessage.pro.

cmake_minimum_required(VERSION 3.14)
project(fademessage LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(INSTALL_EXAMPLEDIR "examples/widgets/effects/fademessage")

find_package(Qt6 COMPONENTS Core)
find_package(Qt6 COMPONENTS Gui)
find_package(Qt6 COMPONENTS Widgets)

add_qt_gui_executable(fademessage
    fademessage.cpp fademessage.h
    main.cpp
)
target_link_libraries(fademessage PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Widgets
)


# Resources:
set(fademessage_resource_files
    "background.jpg"
)

qt6_add_resources(fademessage "fademessage"
    PREFIX
        "/"
    FILES
        ${fademessage_resource_files}
)

install(TARGETS fademessage
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)
