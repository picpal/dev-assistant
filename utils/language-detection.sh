#!/bin/bash

# Language Detection Utility
# Detects the programming language based on file extension or project markers
# Usage: language-detection.sh [file_path or directory]

TARGET="$1"

if [ -z "$TARGET" ]; then
    TARGET="."
fi

# Function to detect language from file extension
detect_from_file() {
    local file="$1"
    local extension="${file##*.}"

    case "$extension" in
        java) echo "java" ;;
        py) echo "python" ;;
        ts|tsx) echo "typescript" ;;
        js|jsx) echo "javascript" ;;
        *) echo "unknown" ;;
    esac
}

# Function to detect language from directory markers
detect_from_directory() {
    local dir="$1"

    # Check for Java project
    if [ -f "$dir/build.gradle" ] || [ -f "$dir/pom.xml" ] || [ -f "$dir/build.gradle.kts" ]; then
        echo "java"
        return
    fi

    # Check for Python project
    if [ -f "$dir/requirements.txt" ] || [ -f "$dir/setup.py" ] || [ -f "$dir/pyproject.toml" ]; then
        echo "python"
        return
    fi

    # Check for TypeScript/JavaScript project
    if [ -f "$dir/package.json" ]; then
        if [ -f "$dir/tsconfig.json" ]; then
            echo "typescript"
        else
            echo "javascript"
        fi
        return
    fi

    echo "unknown"
}

# Main detection logic
if [ -f "$TARGET" ]; then
    # It's a file - detect from extension
    detect_from_file "$TARGET"
elif [ -d "$TARGET" ]; then
    # It's a directory - detect from project markers
    detect_from_directory "$TARGET"
else
    echo "unknown"
fi
