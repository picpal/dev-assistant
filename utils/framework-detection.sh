#!/bin/bash

# Framework Detection Utility
# Detects the framework being used in a project
# Usage: framework-detection.sh [directory]

DIR="$1"

if [ -z "$DIR" ]; then
    DIR="."
fi

# Function to detect Java frameworks
detect_java_framework() {
    local dir="$1"

    # Check for Spring Boot
    if grep -q "spring-boot" "$dir/build.gradle" 2>/dev/null || \
       grep -q "spring-boot" "$dir/pom.xml" 2>/dev/null; then
        echo "spring-boot"
        return
    fi

    # Check for Micronaut
    if grep -q "micronaut" "$dir/build.gradle" 2>/dev/null || \
       grep -q "micronaut" "$dir/pom.xml" 2>/dev/null; then
        echo "micronaut"
        return
    fi

    # Check for Quarkus
    if grep -q "quarkus" "$dir/build.gradle" 2>/dev/null || \
       grep -q "quarkus" "$dir/pom.xml" 2>/dev/null; then
        echo "quarkus"
        return
    fi

    echo "java-unknown"
}

# Function to detect Python frameworks
detect_python_framework() {
    local dir="$1"

    # Check for Flask
    if grep -q "Flask" "$dir/requirements.txt" 2>/dev/null || \
       grep -q "flask" "$dir/pyproject.toml" 2>/dev/null; then
        echo "flask"
        return
    fi

    # Check for FastAPI
    if grep -q "fastapi" "$dir/requirements.txt" 2>/dev/null || \
       grep -q "fastapi" "$dir/pyproject.toml" 2>/dev/null; then
        echo "fastapi"
        return
    fi

    # Check for Django
    if grep -q "Django" "$dir/requirements.txt" 2>/dev/null || \
       grep -q "django" "$dir/pyproject.toml" 2>/dev/null || \
       [ -f "$dir/manage.py" ]; then
        echo "django"
        return
    fi

    echo "python-unknown"
}

# Function to detect JavaScript/TypeScript frameworks
detect_js_framework() {
    local dir="$1"

    if [ ! -f "$dir/package.json" ]; then
        echo "js-unknown"
        return
    fi

    # Check for React
    if grep -q "\"react\"" "$dir/package.json"; then
        # Check for Next.js
        if grep -q "\"next\"" "$dir/package.json"; then
            echo "nextjs"
            return
        fi
        echo "react"
        return
    fi

    # Check for Vue
    if grep -q "\"vue\"" "$dir/package.json"; then
        echo "vue"
        return
    fi

    # Check for Angular
    if grep -q "\"@angular/core\"" "$dir/package.json"; then
        echo "angular"
        return
    fi

    # Check for Svelte
    if grep -q "\"svelte\"" "$dir/package.json"; then
        echo "svelte"
        return
    fi

    echo "js-unknown"
}

# Main detection logic
# First detect language
LANGUAGE=$("$(dirname "$0")/language-detection.sh" "$DIR")

case "$LANGUAGE" in
    java)
        detect_java_framework "$DIR"
        ;;
    python)
        detect_python_framework "$DIR"
        ;;
    typescript|javascript)
        detect_js_framework "$DIR"
        ;;
    *)
        echo "unknown"
        ;;
esac
