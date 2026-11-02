# SPDX-FileCopyrightText: 2026 Jos Zant
# SPDX-License-Identifier: GPL-2.0-or-later
# Based on applets/pager/CMakeLists.txt from KDE plasma-desktop

cmake_minimum_required(VERSION 3.16)
project(virtual_desktop_manager)

set(QT_MIN_VERSION "6.8.0")
set(KF6_MIN_VERSION "6.10.0")

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt6 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS Core DBus Qml Quick)
find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS WindowSystem I18n)
find_package(Plasma REQUIRED)
find_package(PlasmaActivities REQUIRED)
find_package(LibTaskManager CONFIG REQUIRED)

# Own translation domain without translations, so the widget is always in English
add_definitions(-DTRANSLATION_DOMAIN=\"plasma_applet_nl.josz.widepager\")

plasma_add_applet(nl.josz.widepager
    QML_SOURCES
        qml/main.qml
        qml/config.qml
        qml/configGeneral.qml
    CPP_SOURCES
        pagermodel.cpp
        windowmodel.cpp
    RESOURCES
        main.xml
    GENERATE_APPLET_CLASS
    QML_ARGS
        NO_LINT
)

target_link_libraries(nl.josz.widepager PRIVATE
    KF6::WindowSystem
    Plasma::Activities
    PW::LibTaskManager
    Qt::Core
    Qt::DBus
    Qt::Qml
    Qt::Quick
)
