#!/bin/bash

# ANSI escape codes for colors and bold text
RED="\033[1;31m"
GREEN="\033[1;32m"
BOLD="\033[1m"
RESET="\033[0m"

# Clear console
clear

# Check for --status argument
if [[ "$1" == "--status" ]]; then
    # Redirect output to a temporary file
    /Applications/SelfControl.app/Contents/MacOS/selfcontrol-cli print-settings 2>/dev/null > temp_output.txt 2>&1

    # Extract the BlockEndDate value using grep and awk
    block_end_date=$(grep -o 'BlockEndDate = "[^"]*' temp_output.txt | sed 's/BlockEndDate = "//')


    # Remove the temporary file
    rm temp_output.txt

    if [[ "$block_end_date" == "0001-01-01 00:00:00 +0000" ]]; then
      printf "${GREEN}Unlocked${RESET}\n"
      exit 0
    fi

    # Get the current timestamp and convert to Unix timestamp
    current_timestamp=$(date +%s)

    # Convert ISO8601 format to Unix timestamp
    block_end_timestamp=$(date -j -f "%Y-%m-%d %T %z" "$block_end_date" "+%s")

    # Calculate time left
    time_left=$((block_end_timestamp - current_timestamp))
    hours_left=$((time_left / 3600))
    minutes_left=$(( (time_left % 3600) / 60 ))

    # Determine lock status
    if [[ "$hours_left" -gt 0 || "$minutes_left" -gt 0 ]]; then
        lock_status="Locked"
        if [[ "$hours_left" -eq 0 ]]; then
            block_end_time=$(date -r "$block_end_timestamp" "+%H:%M")
        else
            block_end_time=$(date -r "$block_end_timestamp")
        fi
    else
        lock_status="${GREEN}Unlocked{$RESET}"
    fi


    if [[ "$lock_status" == "Locked" ]]; then
        printf "Blocked until ${GREEN}$block_end_time${RESET} (${hours_left}h ${minutes_left}m left)\n"
    else
      printf "${GREEN}$lock_status${RESET}\n"
    fi

    exit 0   
fi


# If no argument provided, enter interactive mode
if [ "$#" -ne 1 ]; then
    printf "${BOLD}Enter the number of minutes for the SelfControl block:${RESET} "
    read MINUTES
else
    MINUTES=$1
fi

# Get the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# List all .selfcontrol files in the directory
BLOCKLISTS=( "$SCRIPT_DIR"/*.selfcontrol )
if [ ${#BLOCKLISTS[@]} -eq 0 ]; then
    printf "${RED}No blocklists found in the script directory.${RESET}\n"
    exit 3
fi

# If there's only one blocklist, use it without asking
if [ ${#BLOCKLISTS[@]} -eq 1 ]; then
    BLOCKLIST_PATH="${BLOCKLISTS[0]}"
else
    printf "${BOLD}Please select a blocklist:${RESET}\n"
    for i in "${!BLOCKLISTS[@]}"; do
        # Extracting only the filename without the extension
        FILE_NAME=$(basename "${BLOCKLISTS[$i]}" .selfcontrol)
        printf "$((i+1)). $FILE_NAME\n"
    done

    # Get user's choice
    printf "${BOLD}Enter the number of your choice:${RESET} "
    read choice
    if ! [[ $choice =~ ^[0-9]+$ ]] || [ "$choice" -le 0 ] || [ "$choice" -gt "${#BLOCKLISTS[@]}" ]; then
        printf "${RED}Invalid choice.${RESET}\n"
        exit 4
    fi

    BLOCKLIST_PATH="${BLOCKLISTS[$((choice-1))]}"
fi

BLOCKLIST_NAME=$(basename "$BLOCKLIST_PATH" .selfcontrol)


# Calculate the end time in ISO8601 format for macOS and UTC
END_TIME_UTC=$(date -u -v+"$MINUTES"M +"%Y-%m-%dT%H:%M:%SZ")

# Calculate the local end time
LOCAL_END_DATE=$(date -v+"$MINUTES"M +"%Y-%m-%d")
LOCAL_END_TIME=$(date -v+"$MINUTES"M +"%H:%M:%S")

# Display only time if the end date is today
TODAYS_DATE=$(date +"%Y-%m-%d")
if [[ "$LOCAL_END_DATE" == "$TODAYS_DATE" ]]; then
    LOCAL_DISPLAY_TIME=$LOCAL_END_TIME
else
    LOCAL_DISPLAY_TIME="$LOCAL_END_DATE $LOCAL_END_TIME"
fi

# Start SelfControl using the full path to the CLI tool
/Applications/SelfControl.app/Contents/MacOS/selfcontrol-cli start --blocklist "$BLOCKLIST_PATH" --enddate "$END_TIME_UTC" &> /dev/null

clear

# Notify the user
printf "SelfControl with ${GREEN}${BOLD}$BLOCKLIST_NAME${RESET} will end at ${GREEN}$LOCAL_DISPLAY_TIME.${RESET}\n"

