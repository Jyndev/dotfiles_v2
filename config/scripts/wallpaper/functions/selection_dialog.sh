#!/bin/bash
select_file() {
    zenity --file-selection --title="$1" --file-filter="$2 | $3"
}
