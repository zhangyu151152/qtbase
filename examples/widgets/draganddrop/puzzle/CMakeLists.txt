# Generated from puzzle.pro.

cmake_minimum_required(VERSION 3.14)
project(puzzle LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(INSTALL_EXAMPLEDIR "examples/widgets/draganddrop/draganddrop_puzzle") # special case

find_package(Qt6 COMPONENTS Core)
find_package(Qt6 COMPONENTS Gui)
find_package(Qt6 COMPONENTS Widgets)

add_qt_gui_executable(draganddrop_puzzle # special case: renamed puzzle
    main.cpp
    mainwindow.cpp mainwindow.h
    pieceslist.cpp pieceslist.h
    puzzlewidget.cpp puzzlewidget.h
)
target_link_libraries(draganddrop_puzzle PUBLIC # special case
    Qt::Core
    Qt::Gui
    Qt::Widgets
)


# Resources:
set(puzzle_resource_files
    "example.jpg"
)

qt6_add_resources(draganddrop_puzzle "puzzle" # special case
    PREFIX
        "/images"
    FILES
        ${puzzle_resource_files}
)

install(TARGETS draganddrop_puzzle # special case: renamed puzzle
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)
