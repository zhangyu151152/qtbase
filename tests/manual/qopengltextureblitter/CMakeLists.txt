# Generated from qopengltextureblitter.pro.

#####################################################################
## qopengltextureblitter Binary:
#####################################################################

add_qt_manual_test(qopengltextureblitter
    GUI
    SOURCES
        main.cpp
        qopengltextureblitwindow.cpp qopengltextureblitwindow.h
    INCLUDE_DIRECTORIES
        .
    PUBLIC_LIBRARIES
        Qt::Gui
        Qt::GuiPrivate
        Qt::OpenGL # special case
)

#### Keys ignored in scope 1:.:.:qopengltextureblitter.pro:<TRUE>:
# TEMPLATE = "app"
