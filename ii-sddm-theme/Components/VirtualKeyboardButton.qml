// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
// Modified by 3d3f for the "ii-sddm-theme" project (2025)
// Licensed under the GNU General Public License v3.0
// See: https://www.gnu.org/licenses/gpl-3.0.txt
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    Layout.preferredHeight: Appearance.formRowHeight
    Layout.preferredWidth: Layout.preferredHeight

    Button {
        id: virtualKeyboardButton

        anchors.fill: parent
        z: 1
        flat: true
        visible: true
        checkable: true
        onClicked: virtualKeyboard.activated = !virtualKeyboard.activated
        checked: virtualKeyboard.activated
        Keys.onReturnPressed: {
            toggle();
            virtualKeyboard.activated = !virtualKeyboard.activated;
        }
        Keys.onEnterPressed: {
            toggle();
            virtualKeyboard.activated = !virtualKeyboard.activated;
        }
        scale: 1
        hoverEnabled: true
        onPressed: pressOverlay.opacity = 0.2
        onReleased: pressOverlay.opacity = 0
        onCanceled: pressOverlay.opacity = 0
        onHoveredChanged: hoverOverlay.opacity = hovered ? 0.08 : 0

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: virtualKeyboardButton.clicked()
        }

        contentItem: Text {
            id: virtualKeyboardButtonText

            text: virtualKeyboardButton.checked ? "keyboard_hide" : "keyboard"
            font.family: "Material Symbols Outlined"
            font.pixelSize: parent.height * 0.5
            color: virtualKeyboardButton.checked ? Colors.on_primary_container : Colors.on_surface_variant
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
            rotation: virtualKeyboardButton.checked ? 180 : 0

            Behavior on rotation {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }

            }

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }

            }

        }

        background: Rectangle {
            id: virtualKeyboardButtonBackground

            radius: 1000
            color: virtualKeyboardButton.checked ? Colors.colPrimaryContainer : Colors.surface_container

            Rectangle {
                id: pressOverlay

                anchors.fill: parent
                radius: parent.radius
                color: Colors.colShadow
                opacity: 0
            }

            Rectangle {
                id: hoverOverlay

                anchors.fill: parent
                implicitHeight: Appearance.formRowHeight
                radius: parent.radius
                color: Colors.colOnLayer3
                opacity: 0
            }

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }

            }

        }

        Behavior on opacity {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }

        }

    }

}
