# Generated from sliders.pro.

cmake_minimum_required(VERSION 3.14)
project(sliders LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(INSTALL_EXAMPLEDIR "examples/widgets/widgets/sliders")

find_package(Qt6 COMPONENTS Core)
find_package(Qt6 COMPONENTS Gui)
find_package(Qt6 COMPONENTS Widgets)

add_qt_gui_executable(sliders
    main.cpp
    slidersgroup.cpp slidersgroup.h
    window.cpp window.h
)
target_link_libraries(sliders PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Widgets
)

install(TARGETS sliders
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)
