# Generated from qtextmarkdownwriter.pro.

#####################################################################
## tst_qtextmarkdownwriter Test:
#####################################################################

# Collect test data
list(APPEND test_data "data/example.md")
list(APPEND test_data "data/blockquotes.md")

add_qt_test(tst_qtextmarkdownwriter
    SOURCES
        tst_qtextmarkdownwriter.cpp
    DEFINES
        SRCDIR=\\\"${CMAKE_CURRENT_SOURCE_DIR}\\\"
    PUBLIC_LIBRARIES
        Qt::CorePrivate
        Qt::Gui
        Qt::GuiPrivate
    TESTDATA ${test_data}
)
