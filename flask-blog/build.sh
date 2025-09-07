#!/bin/bash

# Initialize uv project if needed
if [ ! -f "pyproject.toml" ]; then
    echo "Initializing uv project..."
    uv init
fi

# Install dependencies with uv
echo "Installing dependencies..."
uv sync

# Run tests first
echo "Running tests..."
uv run python -m unittest test_app.py -v

# Check if tests passed
if [ $? -ne 0 ]; then
    echo "Tests failed! Build aborted."
    exit 1
fi

echo "All tests passed!"

# Build the Docker image
echo "Building Docker image..."
docker build -t flask-blog:latest .
