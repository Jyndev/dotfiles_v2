#!/bin/bash
pkill eww
eww daemon --force-wayland
eww open notifications_popup
eww open control_center
eww open notification_panel
~/.config/scripts/daemon_notify/notifications.py &