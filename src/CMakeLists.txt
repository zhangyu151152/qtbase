# special case skip regeneration

# Temporary fix for OpenSSL feature detection until we can provide a
# proper implementation of additional compile tests for library dependencies
# in configure.json

find_package(OpenSSL)
if (NOT OPENSSL_FOUND OR NOT OPENSSL_VERSION VERSION_GREATER_EQUAL "1.1.0")
    set(QT_FEATURE_openssl_runtime OFF CACHE BOOL "" FORCE)
    set(QT_FEATURE_openssl_linked OFF CACHE BOOL "" FORCE)
    set(QT_FEATURE_openssl OFF CACHE BOOL "" FORCE)
endif()

# We need to include the features of a few modules before they are actually declared.
# The feature values are used as conditions for deciding whether bundled 3rd party libraries
# should be built.
# The order of evaluation matters.
qt_feature_evaluate_features("${CMAKE_CURRENT_SOURCE_DIR}/corelib/configure.cmake")
qt_feature_evaluate_features("${CMAKE_CURRENT_SOURCE_DIR}/network/configure.cmake")
qt_feature_evaluate_features("${CMAKE_CURRENT_SOURCE_DIR}/gui/configure.cmake")

add_subdirectory(3rdparty)

function(find_or_build_bootstrap_names)
    if (QT_WILL_BUILD_TOOLS)
        add_subdirectory(tools/bootstrap)  # bootstrap library
    endif()
    add_subdirectory(tools/moc)
    add_subdirectory(tools/rcc)
    add_subdirectory(tools/tracegen)
    add_subdirectory(tools/cmake_automoc_parser)
endfunction()

find_or_build_bootstrap_names()

add_subdirectory(corelib)
if (QT_FEATURE_concurrent)
    add_subdirectory(concurrent)
endif()
if (QT_FEATURE_sql)
    add_subdirectory(sql)
endif()
if (QT_FEATURE_network)
    add_subdirectory(network)
endif()
if (QT_FEATURE_xml)
    add_subdirectory(xml)
endif()
add_subdirectory(tools)

if (QT_FEATURE_dbus)
    add_subdirectory(dbus)
endif()
if(QT_FEATURE_gui)
    add_subdirectory(gui)

    if(QT_FEATURE_opengl)
        add_subdirectory(opengl)
        add_subdirectory(openglextensions)
    endif()

    if(QT_FEATURE_widgets)
        add_subdirectory(widgets)
        if(QT_FEATURE_opengl)
            add_subdirectory(openglwidgets)
        endif()
    endif()
    add_subdirectory(platformsupport)
    add_subdirectory(platformheaders)
endif()
if (QT_FEATURE_testlib)
    add_subdirectory(testlib)
endif()
if(QT_FEATURE_gui AND QT_FEATURE_widgets)
   add_subdirectory(printsupport)
endif()
add_subdirectory(plugins)

add_subdirectory(winmain)

add_subdirectory(android)
