add_subdirectory(3rdparty)

function(find_or_build_bootstrap_names)
    # Move these into their own folder and move this code in the CMakeLists.txt file there!
    set01(_build_tools "x${HOST_QT_TOOLS_DIRECTORY}" STREQUAL "x")

    function(find_or_build_bootstrap_tool name)
        if (_build_tools)
            add_subdirectory(tools/${name})
        else()
            message("Searching for ${name}.")
            find_program("_PROG_${name}" "${name}" PATHS "${HOST_QT_TOOLS_DIRECTORY}" NO_DEFAULT_PATH)
            if (_PROG_${name} STREQUAL "_PROG_${name}-NOTFOUND")
                message(FATAL_ERROR "The name \"${name}\" was not found in the "
                                    "HOST_QT_TOOLS_DIRECTORY (\"${HOST_QT_TOOLS_DIRECTORY}\").")
            else()
                message("${name} was found at ${_PROG_${name}}.")
                add_executable("${name}" IMPORTED GLOBAL)
                set_target_properties("${name}" PROPERTIES IMPORTED_LOCATION "${_PROG_${name}}")

                add_executable("Qt::${name}" ALIAS "${name}")
            endif()
        endif()
    endfunction()

    find_or_build_bootstrap_tool(qmocscanner)
    if (_build_tools)
        add_subdirectory(tools/bootstrap)  # bootstrap library
    endif()
    find_or_build_bootstrap_tool(moc)
    find_or_build_bootstrap_tool(rcc)
    find_or_build_bootstrap_tool(qfloat16-tables)
    find_or_build_bootstrap_tool(tracegen)

    # $<TARGET_FILE:Qt::qmocscanner> does not work during configure run, so export into a plain variable:
    get_target_property(_mocscanner "Qt::qmocscanner" IMPORTED_LOCATION)
    set(QT_MOCSCANNER "${_mocscanner}" CACHE INTERNAL "Qt moc scanner")

    if (_build_tools)
        install(EXPORT "Qt${PROJECT_VERSION_MAJOR}ToolsTargets" NAMESPACE "Qt::" DESTINATION "${INSTALL_LIBDIR}/cmake/Qt${PROJECT_VERSION_MAJOR}")
    endif()
endfunction()

find_or_build_bootstrap_names()

add_subdirectory(corelib)
add_subdirectory(tools)
add_subdirectory(network)
add_subdirectory(xml)
add_subdirectory(dbus)
if(QT_FEATURE_gui)
    add_subdirectory(gui)

    qt_pull_features_into_current_scope(PUBLIC_FEATURES Qt::Gui)
    if(QT_FEATURE_widgets)
        add_subdirectory(widgets)
        if(QT_FEATURE_opengl)
            add_subdirectory(opengl)
        endif()
    endif()
    add_subdirectory(platformsupport)
    add_subdirectory(platformheaders)
endif()
add_subdirectory(testlib)
add_subdirectory(plugins)