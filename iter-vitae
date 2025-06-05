#!/usr/bin/env bash

# iter-vitae - Wrapper script for the Guile Scheme iter-vitae program
#
# This script provides a user-friendly interface to the iter-vitae Guile Scheme
# application, allowing it to be called from the command line like a standard
# executable.

set -euo pipefail

# --- Configuration ---
# GUILE_CODE_FILE="iter-vitae.scm" # Name of your Guile Scheme source file

# --- Helper Functions ---

# Function to display the help message
show_help() {
  echo "Generate a curriculum vitae from a persona file."
  echo ""
  echo "Options:"
  echo "  -l, --locale LOCALE      Specify the locale (e.g., 'en', 'es'). Defaults to 'en'."
  echo "  -p, --persona-file FILE  Specify the persona file (required)."
  echo "  -h, --help               Display this help message and exit."
  echo ""
  echo "Examples:"
  echo "  $(basename "$0") --locale es --persona-file ~/Documents/my_cv_data.scm"
}

# --- Main Logic ---

# Check if Guile is installed
if ! command -v guile &> /dev/null; then
  echo "Error: Guile is not installed or not found in your PATH." >&2
  echo "Please install Guile to run this script." >&2
  exit 1
fi

# Check if the Guile source file exists
if [[ ! -f "$GUILE_CODE_FILE" ]]; then
  echo "Error: Guile source file '$GUILE_CODE_FILE' not found in the current directory." >&2
  echo "Please ensure '$GUILE_CODE_FILE' is in the same directory as this script." >&2
  exit 1
fi

# Initialize variables
LOCALE_ARG=""
PERSONA_FILE_ARG=""
HELP_FLAG=0


# Parse command-line arguments
while (( "$#" )); do
  case "$1" in
    -l|--locale)
      if [[ -n "$2" && "$2" != -* ]]; then
        LOCALE_ARG="-l $2"
        shift 2
      else
        echo "Error: Argument for $1 is missing." >&2
        show_help
        exit 1
      fi
      ;;
    -p|--persona-file)
      if [[ -n "$2" && "$2" != -* ]]; then
        PERSONA_FILE_ARG="-p $2"
        shift 2
      else
        echo "Error: Argument for $1 is missing." >&2
        show_help
        exit 1
      fi
      ;;
    -h|--help)
      HELP_FLAG=1
      shift
      ;;
    -*)
      echo "Error: Unknown option '$1'" >&2
      show_help
      exit 1
      ;;
    *) # Positional arguments (not expected by this script, but good practice)
      echo "Error: Unexpected argument '$1'" >&2
      show_help
      exit 1
      ;;
  esac
done

if [[ "$HELP_FLAG" -eq 1 ]]; then
  show_help
  exit 0
fi

# Check for required persona file
if [[ -z "$PERSONA_FILE_ARG" ]]; then
  echo "Error: The persona file is required. Use -p or --persona-file." >&2
  show_help
  exit 1
fi

# Construct the Guile command
GUILE_COMMAND="guile -s \"$GUILE_CODE_FILE\""

# Add locale argument if provided
if [[ -n "$LOCALE_ARG" ]]; then
  GUILE_COMMAND+=" $LOCALE_ARG"
fi

# Add persona file argument (always required)
GUILE_COMMAND+=" $PERSONA_FILE_ARG"

# Execute the Guile program
eval "$GUILE_COMMAND"
