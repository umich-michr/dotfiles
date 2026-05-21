#!/bin/bash
# THis script is to merge files in this project to a single file with full file paths as headers for eah file content section so that you can feed it to LLM for troubleshooting or understanding it
# Directories or files to skip (e.g., venv, git history)
IGNORE_PATTERN="(\.git|__pycache__|\.venv|\.direnv|\.DS_Store|node_modules|^output.txt)"

# Find all files recursively
find . -type d -name ".git" -prune -o -type f -print | while read -r file; do
  # Clean up the path (remove leading ./)
  rel_path="${file#./}"

  # Skip ignored patterns
  if [[ "$rel_path" =~ $IGNORE_PATTERN ]]; then
    continue
  fi

  # Print the header, the content, and a footer
  echo "================================================"
  echo "FILE: $rel_path"
  echo "================================================"
  cat "$file"
  echo -e "\n-- END OF $rel_path --\n"
done
