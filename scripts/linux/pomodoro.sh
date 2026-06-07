#!/bin/bash

# Pomodoro Timer
# Default times (in minutes)
WORK_TIME=${1:-25}
SHORT_BREAK=${2:-5}
LONG_BREAK=${3:-15}
SESSIONS_UNTIL_LONG_BREAK=4

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display time in MM:SS format
countdown() {
    local minutes=$1
    local message=$2
    local color=$3
    
    local seconds=$((minutes * 60))
    local end_time=$(($(date +%s) + seconds))
    
    while [ $(date +%s) -lt $end_time ]; do
        local remaining=$((end_time - $(date +%s)))
        local mins=$((remaining / 60))
        local secs=$((remaining % 60))
        
        printf "\r${color}${message} %02d:%02d${NC}" $mins $secs
        sleep 1
    done
    
    echo ""
}

# Function to send notification (works on Linux with notify-send)
notify() {
    local message=$1
    echo -e "\a" # System beep
    
    # Try to send desktop notification if notify-send is available
    if command -v notify-send &> /dev/null; then
        notify-send "Pomodoro Timer" "$message"
    fi
    
    echo -e "${YELLOW}🔔 $message${NC}"
}

# Main loop
echo -e "${BLUE}╔════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      Pomodoro Timer Started        ║${NC}"
echo -e "${BLUE}╔════════════════════════════════════╗${NC}"
echo -e "${GREEN}Work time: ${WORK_TIME} minutes${NC}"
echo -e "${GREEN}Short break: ${SHORT_BREAK} minutes${NC}"
echo -e "${GREEN}Long break: ${LONG_BREAK} minutes${NC}"
echo ""

session=1

while true; do
    # Work session
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}Session $session - Time to focus! 🎯${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    countdown $WORK_TIME "⏱️  Working:" "$GREEN"
    notify "Work session complete! Time for a break."
    
    # Determine break type
    if [ $((session % SESSIONS_UNTIL_LONG_BREAK)) -eq 0 ]; then
        # Long break
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BLUE}Long break time! 🌟${NC}"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        countdown $LONG_BREAK "☕ Long break:" "$BLUE"
    else
        # Short break
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${YELLOW}Short break time! ☕${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        countdown $SHORT_BREAK "☕ Break:" "$YELLOW"
    fi
    
    notify "Break is over! Ready for the next session?"
    
    # Ask if user wants to continue
    echo -e "${NC}"
    read -p "Press Enter to start next session, or 'q' to quit: " choice
    
    if [ "$choice" = "q" ] || [ "$choice" = "Q" ]; then
        echo -e "${GREEN}Great work! You completed $session Pomodoro session(s). 🎉${NC}"
        exit 0
    fi
    
    session=$((session + 1))
    echo ""
done
