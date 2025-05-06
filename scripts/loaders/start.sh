#!/bin/bash
pkill eww
eww daemon
eww open notifications_popup
~/.config/scripts/daemon_notify/notifications.py &