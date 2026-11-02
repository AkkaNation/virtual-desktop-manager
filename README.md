# Virtual Desktop Manager

A KDE Plasma 6 panel widget for switching and renaming virtual desktops.

This is a fork of the **Pager** widget (`org.kde.plasma.pager`) that ships with
KDE Plasma, taken from [plasma-desktop](https://invent.kde.org/plasma/plasma-desktop)
`v6.8.2` (`applets/pager`). The original widget is by the KDE Plasma team; see
[Credits](#credits).

## Features

Everything the stock Pager does, plus:

- **Adjustable desktop width.** Choose how wide each desktop cell is:
  - *Fixed width*: a width in pixels per desktop (30–1000 px)
  - *Fill available space*: the widget takes all free space in the panel
  - *Screen aspect ratio*: the stock Pager behaviour
- **Adjustable icon size.** The stock Pager caps application icons at 16 px.
  Here you can set the maximum size yourself (8–128 px).
- **Icons without window outlines.** Application icons can be shown even when
  window outlines are turned off.
- **Rename desktops:**
  - double-click a desktop in the panel to edit its name inline
    (<kbd>Enter</kbd> saves, <kbd>Esc</kbd> cancels, clicking away saves), or
  - edit all names at once under *Desktop names* in the widget settings.

  Names are stored by KWin, so they also change in System Settings.

## Requirements

- KDE Plasma 6.8 (built and tested against 6.8.2)
- Wayland session (renaming desktops uses KWin's D-Bus API, which needs the
  desktop UUIDs that are only available on Wayland; everything else also works
  on X11)

Build dependencies (Arch Linux package names):

```sh
sudo pacman -S --needed cmake extra-cmake-modules qt6-base qt6-declarative \
    kwindowsystem ki18n libplasma plasma-activities plasma-workspace
```

## Build and install

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cmake --install build
systemctl --user restart plasma-plasmashell
```

Then add it to a panel: *Enter Edit Mode → Add Widgets → "Virtual Desktop Manager"*.

The plugin is installed as
`/usr/lib/qt6/plugins/plasma/applets/nl.josz.widepager.so`. It is compiled
against your Plasma version, so rebuild it after a major Plasma update.

### Uninstall

```sh
sudo xargs rm -v < build/install_manifest.txt
systemctl --user restart plasma-plasmashell
```

## Changes from upstream

Modified in 2026 by Jos Zant, compared to the Pager in plasma-desktop `v6.8.2`:

- `CMakeLists.txt`: new standalone build file; plugin ID `nl.josz.widepager`;
  separate translation domain so the UI is always in English
- `metadata.json`: new name and description
- `main.xml`: new options `sizeMode`, `desktopWidth` and `maxIconSize`;
  `showWindowIcons` is on by default
- `qml/main.qml`: width modes, configurable icon size, icons without outlines,
  inline rename on double-click; the model is only reset after a real window
  drag, so double-clicks on windows work
- `qml/configGeneral.qml`: settings for the above and a list of desktop names
- `pagermodel.cpp/.h`: new `renameDesktop()` method (via KWin D-Bus)

`windowmodel.cpp/.h` and `qml/config.qml` are unchanged.

## Forking

Go ahead. If you publish your own version, change the plugin ID (the target
name in `CMakeLists.txt`) so it does not clash with this one, and keep the
license and copyright notices.

## Credits

Based on the KDE Plasma Pager widget. Original authors, according to the source
file headers: Daniel Laidig, Luís Gabriel Lima, Eike Hein, Kai Uwe Broulik,
David Edmundson, Marco Martin and the KDE Plasma team.

## License

[GPL-2.0-or-later](LICENSE), the same license as the original Pager widget.
