#!/bin/bash

# This script is used to update & upgrade the necessary packages for the system.
# It will have a part for MacOS and a part for Linux.
# MacOS will use brew to update and upgrade the packages.
# Linux will use nala, flatpak, and brew to update and upgrade the packages.

# Created output file
OUTPUT_FILE="$HOME/Package-Updates.md"

# Function to format current date and time
get_datetime() {
  date "+%Y-%m-%d %H:%M:%S"
}

# Clear previous output file and initialize it with a header
echo "# Package Updates $(get_datetime)" >"$OUTPUT_FILE"
echo "" >>"$OUTPUT_FILE"

# Check the operating system of the device
OS=$(uname -s)

# Check if OS is MacOS
if [ "$OS" == "Darwin" ]; then
  echo "You are using MacOS. Packages will be updated using brew."
  # Update Homebrew
  echo "Updatinig Homebrew..."
  brew update

  # Ask user if they want to upgrade all packages
  read -p "Would you like to upgrade all packages? (y/n): " answer

  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "Proceeding with package upgrades..."
    echo "## Homebrew Updates" >>"$OUTPUT_FILE"
    echo "" >>"$OUTPUT_FILE"
    echo "| Package | Old Version | New Version |" >>"$OUTPUT_FILE"
    echo "|---------|-------------|------------|" >>"$OUTPUT_FILE"

    # Capture the output of brew upgrade
    brew upgrade | tee /tmp/brew_upgrade_output.txt

    # Parse the brew upgrade output to extract package info
    # Format: brew upgrade formulas look like: ==> Upgrading 1 outdated package:
    # package 1.2.3 -> 1.2.4
    grep -E " [0-9]+\.[0-9]+.* -> " /tmp/brew_output.txt | while read -r line; do
      package=$(echo "$line" | awk '{print $1}')
      old_version=$(echo "$line" | awk '{print $2}')
      new_version=$(echo "$line" | awk '{print $4}')
      echo "| $package | $old_version | $new_version |" >>"$OUTPUT_FILE"
    done

    # If no packages were upgraded, note that
    if ! grep -q " -> " /tmp/brew_output.txt; then
      echo "| No packages needed upgrading | - | - |" >>"$OUTPUT_FILE"
    fi
    # Extract and format the upgrade information (we'll refine this in the next step)
    echo "Package upgrade information will be formatted and added to $OUTPUT_FILE"
  else
    echo "Skipping package upgrade."
    echo "You can manually upgrade packages using 'brew upgrade'."
    echo "Exiting script."
  fi

  # Check if OS is Linux
elif [ "$OS" == "Linux" ]; then
  echo "You are using Linux! Packages will be updated using nala, flatpake, and linuxbrew."

  # Check if user can run sudo
  if sudo -v; then
    echo "You have sudo privileges. Proceeding with updates..."
  else
    echo "You don't have sudo privileges. Please run the script with sudo."
    exit 1
  fi

  # Update using nala/apt
  echo "## System Updates (Nala/APT)" >>"$OUTPUT_FILE"
  echo "" >>"$OUTPUT_FILE"
  echo "| Package | Old Version | New Version |" >>"$OUTPUT_FILE"
  echo "|---------|-------------|------------|" >>"$OUTPUT_FILE"

  # Check if nala is installed, use apt if not
  if command -v nala &>/dev/null; then
    echo "Using nala for system package management..."
    sudo nala update
    sudo nala upgrade

    # Parse nala output to extract package upgrade info
    if grep -q "upgraded" /tmp/nala_output.txt; then
      # Extract lines with package updates (this is a simplification - may need adjusting)
      grep -A 1 "The following packages will be upgraded" /tmp/nala_output.txt | grep -v "The following" | grep -v "\-\-" | tr ' ' '\n' | grep -v "^$" | while read -r package; do
        # For each package, we'll just show that it was updated without version info
        # (Getting exact version info from apt/nala is more complex)
        echo "| $package | Updated | Latest |" >>"$OUTPUT_FILE"
      done
    else
      echo "| No packages needed upgrading | - | - |" >>"$OUTPUT_FILE"
    fi
  else
    echo "Nala not found, using apt instead..."
    sudo apt update
    # shellcheck disable=SC2024 # /tmp is world-writable; only apt needs root, not the redirect
    sudo apt upgrade -y >/tmp/apt_output.txt 2>&1

    # Parse apt output (similar approach to nala)
    if grep -q "upgraded" /tmp/apt_output.txt; then
      grep -A 1 "The following packages will be upgraded" /tmp/apt_output.txt | grep -v "The following" | grep -v "\-\-" | tr ' ' '\n' | grep -v "^$" | while read -r package; do
        echo "| $package | Updated | Latest |" >>"$OUTPUT_FILE"
      done
    else
      echo "| No packages needed upgrading | - | - |" >>"$OUTPUT_FILE"
    fi
  fi

  # Update flatpak if available
  if command -v flatpak &>/dev/null; then
    echo "" >>"$OUTPUT_FILE"
    echo "## Flatpak Updates" >>"$OUTPUT_FILE"
    echo "" >>"$OUTPUT_FILE"
    echo "| Package | Old Version | New Version |" >>"$OUTPUT_FILE"
    echo "|---------|-------------|------------|" >>"$OUTPUT_FILE"

    echo "Updating Flatpak packages..."
    flatpak update -y >/tmp/flatpak_output.txt 2>&1

    # Parse flatpak output
    if grep -q "Installing\|Updating" /tmp/flatpak_output.txt; then
      grep -E "Installing|Updating" /tmp/flatpak_output.txt | while read -r line; do
        if [[ "$line" =~ Installing|Updating\ +([^\ ]+)\ +([^\ ]+)\ +to\ +([^\ ]+) ]]; then
          app="${BASH_REMATCH[1]}"
          old_version="${BASH_REMATCH[2]}"
          new_version="${BASH_REMATCH[3]}"
          echo "| $app | $old_version | $new_version |" >>"$OUTPUT_FILE"
        fi
      done
    else
      echo "| No packages needed upgrading | - | - |" >>"$OUTPUT_FILE"
    fi
  fi

  # Update Linuxbrew if available
  if command -v brew &>/dev/null; then
    echo "" >>"$OUTPUT_FILE"
    echo "## Linuxbrew Updates" >>"$OUTPUT_FILE"
    echo "" >>"$OUTPUT_FILE"
    echo "| Package | Old Version | New Version |" >>"$OUTPUT_FILE"
    echo "|---------|-------------|------------|" >>"$OUTPUT_FILE"

    echo "Updating Linuxbrew packages..."
    brew update
    brew upgrade >/tmp/linuxbrew_output.txt 2>&1

    # Parse the brew upgrade output (same as macOS section)
    grep -E " [0-9]+\.[0-9]+.* -> " /tmp/linuxbrew_output.txt | while read -r line; do
      package=$(echo "$line" | awk '{print $1}')
      old_version=$(echo "$line" | awk '{print $2}')
      new_version=$(echo "$line" | awk '{print $4}')
      echo "| $package | $old_version | $new_version |" >>"$OUTPUT_FILE"
    done

    if ! grep -q " -> " /tmp/linuxbrew_output.txt; then
      echo "| No packages needed upgrading | - | - |" >>"$OUTPUT_FILE"
    fi
  fi
else
  echo "Unsupported operating system: $OS"
  exit 1
fi

echo "All package managers have been updated. Details saved to $OUTPUT_FILE"
