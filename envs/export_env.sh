#!/bin/bash
# Export conda environment to clean YAML file
# Usage: ./export_env.sh <env-name>

# Check if environment name is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <env-name>"
    echo "Example: $0 my-dev-env"
    exit 1
fi

ENV_NAME="$1"
OUTPUT_FILE="${ENV_NAME}.yml"

echo "Exporting conda environment: $ENV_NAME"

# Check if environment exists
if ! conda env list | grep -q "^$ENV_NAME "; then
    echo "Error: Environment '$ENV_NAME' not found."
    echo ""
    echo "Available environments:"
    conda env list
    exit 1
fi

# Export environment with --from-history (only explicitly installed packages)
echo "Creating $OUTPUT_FILE..."
conda env export --name "$ENV_NAME" --from-history > "$OUTPUT_FILE"

# Remove the prefix line (contains local paths)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' '/^prefix:/d' "$OUTPUT_FILE"
else
    # Linux
    sed -i '/^prefix:/d' "$OUTPUT_FILE"
fi

echo "✓ Environment exported to $OUTPUT_FILE"
echo ""
echo "File contents:"
echo "----------------------------------------"
cat "$OUTPUT_FILE"
echo "----------------------------------------"
echo ""
echo "To recreate this environment:"
echo "  conda env create -f $OUTPUT_FILE"
