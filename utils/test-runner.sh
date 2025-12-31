#!/bin/bash

# Test Runner Utility
# Runs tests based on detected framework and language
# Usage: test-runner.sh [directory] [test_file_or_path]

DIR="${1:-.}"
TEST_TARGET="$2"

# Detect framework
FRAMEWORK=$("$(dirname "$0")/framework-detection.sh" "$DIR")

echo "Detected framework: $FRAMEWORK"

case "$FRAMEWORK" in
    spring-boot)
        echo "Running Java tests with Gradle/Maven..."
        if [ -f "$DIR/gradlew" ]; then
            cd "$DIR" && ./gradlew test
        elif [ -f "$DIR/build.gradle" ]; then
            cd "$DIR" && gradle test
        elif [ -f "$DIR/pom.xml" ]; then
            cd "$DIR" && mvn test
        else
            echo "No build tool found for Java project"
            exit 1
        fi
        ;;

    micronaut|quarkus)
        echo "Running Java tests with Gradle/Maven..."
        if [ -f "$DIR/gradlew" ]; then
            cd "$DIR" && ./gradlew test
        elif [ -f "$DIR/pom.xml" ]; then
            cd "$DIR" && mvn test
        else
            echo "No build tool found"
            exit 1
        fi
        ;;

    flask|fastapi|django|python-unknown)
        echo "Running Python tests with pytest..."
        if [ -n "$TEST_TARGET" ]; then
            cd "$DIR" && pytest "$TEST_TARGET" -v
        else
            cd "$DIR" && pytest -v
        fi
        ;;

    react|nextjs|vue|angular|svelte|js-unknown)
        echo "Running JavaScript/TypeScript tests with npm/jest..."
        if [ -f "$DIR/package.json" ]; then
            cd "$DIR" && npm test
        else
            echo "No package.json found"
            exit 1
        fi
        ;;

    *)
        echo "Unknown framework: $FRAMEWORK"
        echo "Cannot determine how to run tests"
        exit 1
        ;;
esac
