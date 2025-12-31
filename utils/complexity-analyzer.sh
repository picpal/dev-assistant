#!/bin/bash

# Complexity Analyzer Utility
# Calculates cyclomatic complexity and other code metrics
# Usage: complexity-analyzer.sh <file_path>

FILE="$1"

if [ -z "$FILE" ]; then
    echo "Usage: complexity-analyzer.sh <file_path>"
    exit 1
fi

if [ ! -f "$FILE" ]; then
    echo "File not found: $FILE"
    exit 1
fi

# Detect language
EXTENSION="${FILE##*.}"

case "$EXTENSION" in
    java)
        echo "Analyzing Java file complexity..."
        # Count lines
        LINES=$(wc -l < "$FILE")
        # Count methods (approximate)
        METHODS=$(grep -c "public\|private\|protected" "$FILE")
        # Count conditionals (if, for, while, case)
        CONDITIONALS=$(grep -c "if\|for\|while\|case" "$FILE")
        # Estimate cyclomatic complexity (conditionals + 1)
        COMPLEXITY=$((CONDITIONALS + 1))

        echo "File: $FILE"
        echo "Lines of code: $LINES"
        echo "Methods (approx): $METHODS"
        echo "Conditional statements: $CONDITIONALS"
        echo "Estimated cyclomatic complexity: $COMPLEXITY"

        if [ $COMPLEXITY -gt 20 ]; then
            echo "⚠️  High complexity detected (>20)"
        elif [ $COMPLEXITY -gt 10 ]; then
            echo "⚠️  Moderate complexity (>10)"
        else
            echo "✓ Low complexity"
        fi
        ;;

    py)
        echo "Analyzing Python file complexity..."
        # Check if radon is installed for better analysis
        if command -v radon &> /dev/null; then
            echo "Using radon for detailed analysis:"
            radon cc "$FILE" -s
        else
            # Fallback to basic analysis
            LINES=$(wc -l < "$FILE")
            FUNCTIONS=$(grep -c "^def " "$FILE")
            CONDITIONALS=$(grep -c "if\|for\|while" "$FILE")
            COMPLEXITY=$((CONDITIONALS + 1))

            echo "File: $FILE"
            echo "Lines of code: $LINES"
            echo "Functions: $FUNCTIONS"
            echo "Conditional statements: $CONDITIONALS"
            echo "Estimated cyclomatic complexity: $COMPLEXITY"

            if [ $COMPLEXITY -gt 20 ]; then
                echo "⚠️  High complexity detected (>20)"
            elif [ $COMPLEXITY -gt 10 ]; then
                echo "⚠️  Moderate complexity (>10)"
            else
                echo "✓ Low complexity"
            fi

            echo ""
            echo "Tip: Install radon for better analysis: pip install radon"
        fi
        ;;

    js|jsx|ts|tsx)
        echo "Analyzing JavaScript/TypeScript file complexity..."
        # Check if eslint with complexity plugin is available
        if command -v eslint &> /dev/null; then
            echo "Using eslint for analysis:"
            eslint "$FILE" --rule 'complexity: [error, 10]' --no-eslintrc
        else
            # Fallback to basic analysis
            LINES=$(wc -l < "$FILE")
            FUNCTIONS=$(grep -c "function\|=>" "$FILE")
            CONDITIONALS=$(grep -c "if\|for\|while\|case\|?.*:" "$FILE")
            COMPLEXITY=$((CONDITIONALS + 1))

            echo "File: $FILE"
            echo "Lines of code: $LINES"
            echo "Functions (approx): $FUNCTIONS"
            echo "Conditional statements: $CONDITIONALS"
            echo "Estimated cyclomatic complexity: $COMPLEXITY"

            if [ $COMPLEXITY -gt 20 ]; then
                echo "⚠️  High complexity detected (>20)"
            elif [ $COMPLEXITY -gt 10 ]; then
                echo "⚠️  Moderate complexity (>10)"
            else
                echo "✓ Low complexity"
            fi

            echo ""
            echo "Tip: Use eslint with complexity rules for better analysis"
        fi
        ;;

    *)
        echo "Unsupported file type: .$EXTENSION"
        exit 1
        ;;
esac
