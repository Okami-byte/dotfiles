#!/bin/bash

# An Update to the bash script to reload my entire system for the most part
# Added a few things that I learned from my project at work like
# Functions, Calling functiosn, esac, values, etc

# Color constants
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Loading animation function
show_loading() {
  local message="$1"
  local duration=${2:-2}

  echo -ne "${CYAN}${message}${NC}"
  for i in {1..3}; do
    for j in {1..3}; do
      echo -ne "."
      sleep 0.2
    done
    echo -ne "\r${CYAN}${message}${NC}   \r${CYAN}${message}${NC}"
    sleep 0.1
  done
  echo -e " ${GREEN}✓${NC}"
}

# Function to restart yabai
restart_yabai() {
  show_loading "Restarting yabai"
  yabai --restart-service
}

# Function to restart skhd
restart_skhd() {
  show_loading "Restarting skhd"
  skhd --restart-service
}

# Function to restart sketchybar
restart_sketchybar() {
  show_loading "Restarting sketchybar"
  brew services restart sketchybar
}

# Function to restart borders
restart_borders() {
  show_loading "Restarting borders"
  brew services restart borders
}

# Function to restart all services
restart_all() {
  restart_yabai
  restart_skhd
  restart_sketchybar
  restart_borders
  echo -e "\n${GREEN}${BOLD}All services restarted successfully!${NC}"
}

# Function to display the menu and get user selection
show_menu() {
  clear
  echo -e "${BOLD}${PURPLE}╭───────────────────────────────────╮${NC}"
  echo -e "${BOLD}${PURPLE}│       ${WHITE}Rice Reloader Menu${PURPLE}          │${NC}"
  echo -e "${BOLD}${PURPLE}╰───────────────────────────────────╯${NC}"
  echo
  echo -e "${YELLOW}1)${NC} ${CYAN}Restart Yabai${NC}"
  echo -e "${YELLOW}2)${NC} ${CYAN}Restart SKHD${NC}"
  echo -e "${YELLOW}3)${NC} ${CYAN}Restart Sketchybar${NC}"
  echo -e "${YELLOW}4)${NC} ${CYAN}Restart Borders${NC}"
  echo -e "${YELLOW}5)${NC} ${GREEN}Restart All Services${NC}"
  echo
  echo -e "${RED}q)${NC} ${WHITE}Quit${NC}"
  echo
  echo -ne "${BOLD}Please enter your choice ${YELLOW}[1-5/q]${NC}: "
}

# Check if command line argument was provided
if [ $# -eq 0 ]; then
  # No arguments provided, show interactive menu
  while true; do
    show_menu
    read choice

    case $choice in
    1)
      restart_yabai
      ;;
    2)
      restart_skhd
      ;;
    3)
      restart_sketchybar
      ;;
    4)
      restart_borders
      ;;
    5)
      restart_all
      ;;
    q | Q)
      echo -e "${GREEN}Exiting...${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid option. Press Enter to try again...${NC}"
      read
      ;;
    esac
  done
else
  # Command line argument provided, use the original behavior
  case "$1" in
  "yabai") restart_yabai ;;
  "skhd") restart_skhd ;;
  "sketchybar") restart_sketchybar ;;
  "borders") restart_borders ;;
  "all") restart_all ;;
  *)
    echo "Usage: $0 {yabai|skhd|sketchybar|borders|all}"
    echo "Or run without arguments for interactive menu."
    ;;
  esac
fi
