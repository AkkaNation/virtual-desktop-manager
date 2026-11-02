    /*
 *  SPDX-FileCopyrightText: 2013 David Edmundson <davidedmundson@kde.org>
 *  SPDX-FileCopyrightText: 2016 Eike Hein <hein@kde.org>
 *  SPDX-FileCopyrightText: 2026 Jos Zant (modified for Virtual Desktop Manager)
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.kcmutils as KCM
import plasma.applet.nl.josz.widepager

KCM.SimpleKCM {
    id: root
    readonly property bool isActivityPager: Plasmoid.pluginName === "org.kde.plasma.activitypager"

    property int cfg_displayedText
    property alias cfg_showWindowOutlines: showWindowOutlines.checked
    property alias cfg_showWindowIcons: showWindowIcons.checked
    property int cfg_currentDesktopSelected
    property alias cfg_pagerLayout: pagerLayout.currentIndex
    property alias cfg_showOnlyCurrentScreen: showOnlyCurrentScreen.checked
    property alias cfg_wrapPage: wrapPage.checked

    // Desktop names are stored by KWin, not in the widget configuration
    property bool unsavedChanges: false

    function saveConfig() {
        for (let i = 0; i < desktopNameRepeater.count; ++i) {
            const field = desktopNameRepeater.itemAt(i);
            if (field && field.text.trim().length > 0 && field.text !== field.display) {
                desktopsModel.renameDesktop(field.desktopId, field.text);
            }
        }
        unsavedChanges = false;
    }

    PagerModel {
        id: desktopsModel
        enabled: !root.isActivityPager
        pagerType: PagerModel.VirtualDesktops
    }
    property alias cfg_sizeMode: sizeMode.currentIndex
    property alias cfg_desktopWidth: desktopWidth.value
    property alias cfg_maxIconSize: maxIconSize.value

    Kirigami.FormLayout {
        QQC2.ButtonGroup {
            id: displayedTextGroup
        }

        QQC2.ButtonGroup {
            id: currentDesktopSelectedGroup
        }

        QQC2.CheckBox {
            id: showWindowOutlines

            Kirigami.FormData.label: i18nc("@title:group prefix for checkbox group", "General:")

            text: i18nc("@option:check", "Show window outlines")
        }

        QQC2.CheckBox {
            id: showWindowIcons
            text: i18nc("@option:check", "Show application icons on window outlines")
        }

        QQC2.CheckBox {
            id: showOnlyCurrentScreen
            text: i18nc("@option:check", "Show only current screen")
        }

        QQC2.CheckBox {
            id: wrapPage
            text: i18nc("@option:check", "Navigation wraps around")
        }


        Item {
            Kirigami.FormData.isSection: true
        }

        QQC2.ComboBox {
            id: sizeMode
            Kirigami.FormData.label: "Desktop width:"
            model: ["Fixed width", "Fill available space", "Screen aspect ratio (stock Pager)"]
        }

        QQC2.SpinBox {
            id: desktopWidth
            Kirigami.FormData.label: "Width:"
            visible: sizeMode.currentIndex === 0
            from: 30
            to: 1000
            stepSize: 10
            editable: true
            textFromValue: (value, locale) => value + " px"
            valueFromText: (text, locale) => parseInt(text)
        }

        QQC2.SpinBox {
            id: maxIconSize
            Kirigami.FormData.label: "Maximum icon size:"
            from: 8
            to: 128
            stepSize: 2
            enabled: showWindowIcons.checked
            editable: true
            textFromValue: (value, locale) => value + " px"
            valueFromText: (text, locale) => parseInt(text)
        }

        Item {
            Kirigami.FormData.isSection: true
        }


        QQC2.ComboBox {
            id: pagerLayout

            Kirigami.FormData.label: i18nc("@title:listbox", "Layout:")

            model: [i18nc("@item:inlistbox The pager layout", "Default"), i18nc("@item:inlistbox The pager layout", "Horizontal"), i18nc("@item:inlistbox The pager layout", "Vertical")]
            visible: root.isActivityPager
        }


        Item {
            Kirigami.FormData.isSection: true
            visible: root.isActivityPager
        }


        QQC2.RadioButton {
            id: noTextRadio

            Kirigami.FormData.label: i18nc("@title:group prefix for radiobutton group", "Text display:")

            QQC2.ButtonGroup.group: displayedTextGroup
            text: i18nc("@option:radio text display", "No text")
            checked: root.cfg_displayedText === 2
            onToggled: if (checked) root.cfg_displayedText = 2;
        }

        QQC2.RadioButton {
            id: desktopNumberRadio
            QQC2.ButtonGroup.group: displayedTextGroup
            text: isActivityPager ? i18nc("@option:radio text display", "Activity number") : i18nc("@option:radio text display", "Desktop number")
            checked: root.cfg_displayedText === 0
            onToggled: if (checked) root.cfg_displayedText = 0;
        }

        QQC2.RadioButton {
            id: desktopNameRadio
            QQC2.ButtonGroup.group: displayedTextGroup
            text: isActivityPager ? i18nc("@option:radio text display", "Activity name") : i18nc("@option:radio text display", "Desktop name")
            checked: root.cfg_displayedText === 1
            onToggled: if (checked) root.cfg_displayedText = 1;
        }


        Item {
            Kirigami.FormData.isSection: true
        }


        QQC2.RadioButton {
            id: doesNothingRadio

            Kirigami.FormData.label: root.isActivityPager
                ? i18nc("@label Start of the sentence 'Selecting current activity does nothing/shows the desktop'", "Selecting current Activity:")
                : i18nc("@label Start of the sentence 'Selecting current virtual desktop does nothing/shows the desktop'", "Selecting current virtual desktop:")

            QQC2.ButtonGroup.group: currentDesktopSelectedGroup
            text: i18nc("option:check completes the sentence 'Selecting current activity/virtual desktop does nothing'", "Does nothing")
            checked: root.cfg_currentDesktopSelected === 0
            onToggled: if (checked) root.cfg_currentDesktopSelected = 0;
        }

        QQC2.RadioButton {
            id: showsDesktopRadio
            QQC2.ButtonGroup.group: currentDesktopSelectedGroup
            text: i18nc("option:check completes the sentence 'Selecting current activity/virtual desktop shows the desktop'", "Shows the desktop")
            checked: root.cfg_currentDesktopSelected === 1
            onToggled: if (checked) root.cfg_currentDesktopSelected = 1;
        }
    
        Item {
            Kirigami.FormData.isSection: true
            visible: !root.isActivityPager
        }

        Repeater {
            id: desktopNameRepeater
            model: root.isActivityPager ? null : desktopsModel

            delegate: QQC2.TextField {
                required property string display
                required property int index
                required property var model

                readonly property string desktopId: model.TasksModel?.virtualDesktop ?? ""

                Kirigami.FormData.label: index === 0 ? "Desktop names:" : ""
                placeholderText: "Desktop " + (index + 1)
                text: display
                onTextEdited: root.unsavedChanges = true
            }
        }

        QQC2.Label {
            visible: !root.isActivityPager
            text: "Tip: double-click a desktop in the panel to rename it directly."
            font: Kirigami.Theme.smallFont
            opacity: 0.7
            wrapMode: Text.WordWrap
            Layout.maximumWidth: Kirigami.Units.gridUnit * 20
        }
    }
}
