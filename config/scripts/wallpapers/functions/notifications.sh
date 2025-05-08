#!/bin/bash
notify() {
    notify-send "$TITULO_APP $ICONO_APP" "$1"
}