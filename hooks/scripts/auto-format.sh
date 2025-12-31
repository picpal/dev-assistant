#!/bin/bash

# Auto-format script for Java, Python, and TypeScript/JavaScript files
# Usage: auto-format.sh <file_path>

FILE_PATH="$1"

if [ -z "$FILE_PATH" ]; then
    echo "No file path provided"
    exit 0
fi

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
    echo "File not found: $FILE_PATH"
    exit 0
fi

# Get file extension
EXTENSION="${FILE_PATH##*.}"

case "$EXTENSION" in
    java)
        # Format Java files
        if command -v google-java-format &> /dev/null; then
            echo "Formatting Java file with google-java-format..."
            google-java-format --replace "$FILE_PATH"
        elif command -v spotlessApply &> /dev/null; then
            echo "Formatting Java file with Spotless..."
            ./gradlew spotlessApply
        else
            echo "No Java formatter found (google-java-format or spotless)"
        fi
        ;;

    py)
        # Format Python files
        if command -v black &> /dev/null; then
            echo "Formatting Python file with black..."
            black "$FILE_PATH"

            # Also run isort for imports
            if command -v isort &> /dev/null; then
                echo "Sorting imports with isort..."
                isort "$FILE_PATH"
            fi
        else
            echo "No Python formatter found (black)"
        fi
        ;;

    js|jsx|ts|tsx)
        # Format JavaScript/TypeScript files
        if command -v prettier &> /dev/null; then
            echo "Formatting JS/TS file with prettier..."
            prettier --write "$FILE_PATH"
        elif [ -f "node_modules/.bin/prettier" ]; then
            echo "Formatting JS/TS file with local prettier..."
            npx prettier --write "$FILE_PATH"
        else
            echo "No JS/TS formatter found (prettier)"
        fi
        ;;

    *)
        # Unsupported file type, skip formatting
        echo "Skipping formatting for unsupported file type: .$EXTENSION"
        ;;
esac

exit 0
