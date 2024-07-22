#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

print_status() {
	local save_int="$(get_tmux_option "$auto_save_interval_option")"
	local status_opt="$(get_tmux_option "$status_option" "$status_option_default")"
  local last_save_stamp="$(get_tmux_option $last_auto_save_option )"

  local current_stamp="$( date +%s )"
  local duration="$(date +%-M -d @"$(bc <<< "$current_stamp - $last_save_stamp")")"
  local status=""
	local style_wrap
	
  if [ $save_int -gt 0 ]; then
		style_wrap="$(get_tmux_option "$status_on_style_wrap_option" "")"
	else
		style_wrap="$(get_tmux_option "$status_off_style_wrap_option" "")"
		save_int="off"
	fi

  if [ $status_opt == "duration" ]; then
    status="$duration"
  elif [ $status_opt == "both" ]; then
    status="$duration$save_int"
  else
    status="$save_int"
  fi
  
	if [ -n "$style_wrap" ]; then
		status="${style_wrap/$status_wrap_string/$status}"
	fi
	echo "$status"
}
print_status
