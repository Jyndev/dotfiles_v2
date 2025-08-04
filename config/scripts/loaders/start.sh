#!/bin/bash
pkill eww
eww daemon
eww open notifications_popup
eww open dashboard
eww open control_center
~/.config/scripts/daemon_notify/notifications.py &