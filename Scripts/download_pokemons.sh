#!/bin/bash

# Usage function
usage() {
  echo "Usage: $0 -s <start_number> -e <end_number> [-j <num_processes>]"
  exit 1
}

# Check for the required arguments
if [ $# -lt 4 ] || [ $# -gt 6 ]; then
  usage
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s)
      start_number="$2"
      shift 2
      ;;
    -e)
      end_number="$2"
      shift 2
      ;;
    -j)
      num_processes="$2"
      shift 2
      ;;
    *)
      usage
      ;;
  esac
done


# Call the download script
python Scripts/python/download_sprites.py --start-number "$start_number" --end-number "$end_number" --num-processes "$num_processes"

# Call the ConvertAnimData script
python Scripts/python/ConvertAnimData.py
