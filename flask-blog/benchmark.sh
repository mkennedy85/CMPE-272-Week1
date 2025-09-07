#!/bin/bash

# Performance Benchmarking Script for VM vs Docker Comparison
# Usage: ./benchmark.sh [vm|docker] [app_url]

PLATFORM=${1:-"unknown"}
APP_URL=${2:-"http://localhost:5001"}
RESULTS_DIR="benchmark_results"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULT_FILE="${RESULTS_DIR}/${PLATFORM}_benchmark_${TIMESTAMP}.txt"

# Create results directory
mkdir -p "$RESULTS_DIR"

echo "=== Performance Benchmark for $PLATFORM ===" | tee "$RESULT_FILE"
echo "Timestamp: $(date)" | tee -a "$RESULT_FILE"
echo "Platform: $PLATFORM" | tee -a "$RESULT_FILE"
echo "App URL: $APP_URL" | tee -a "$RESULT_FILE"
echo "" | tee -a "$RESULT_FILE"

# System Information
echo "=== System Information ===" | tee -a "$RESULT_FILE"
echo "CPU Information:" | tee -a "$RESULT_FILE"
if command -v lscpu &> /dev/null; then
    lscpu | grep -E "Model name|CPU\(s\)|Thread|Core" | tee -a "$RESULT_FILE"
else
    sysctl -n machdep.cpu.brand_string 2>/dev/null | tee -a "$RESULT_FILE" || echo "CPU info not available" | tee -a "$RESULT_FILE"
fi

echo "" | tee -a "$RESULT_FILE"
echo "Memory Information:" | tee -a "$RESULT_FILE"
if command -v free &> /dev/null; then
    free -h | tee -a "$RESULT_FILE"
else
    # macOS memory info
    vm_stat | head -10 | tee -a "$RESULT_FILE" 2>/dev/null || echo "Memory info not available" | tee -a "$RESULT_FILE"
fi

echo "" | tee -a "$RESULT_FILE"

# Startup Time Measurement
echo "=== Startup Time Measurement ===" | tee -a "$RESULT_FILE"
echo "Measuring startup time..." | tee -a "$RESULT_FILE"

if [ "$PLATFORM" = "vm" ]; then
    echo "Starting VM..." | tee -a "$RESULT_FILE"
    START_TIME=$(date +%s.%N)
    vagrant up 2>&1 | grep -E "started|ready" | tail -1 | tee -a "$RESULT_FILE"
    END_TIME=$(date +%s.%N)
    STARTUP_TIME=$(echo "$END_TIME - $START_TIME" | bc)
    echo "VM Startup Time: ${STARTUP_TIME} seconds" | tee -a "$RESULT_FILE"
elif [ "$PLATFORM" = "docker" ]; then
    echo "Starting Docker container..." | tee -a "$RESULT_FILE"
    START_TIME=$(date +%s.%N)
    docker run -d -p 5001:5001 --name flask-blog-benchmark flask-blog:latest 2>&1 | tee -a "$RESULT_FILE"
    # Wait for container to be ready
    sleep 2
    END_TIME=$(date +%s.%N)
    STARTUP_TIME=$(echo "$END_TIME - $START_TIME" | bc)
    echo "Docker Startup Time: ${STARTUP_TIME} seconds" | tee -a "$RESULT_FILE"
fi

# Wait for application to be ready
echo "Waiting for application to be ready..." | tee -a "$RESULT_FILE"
for i in {1..30}; do
    if curl -s "$APP_URL" > /dev/null 2>&1; then
        echo "Application ready after $i seconds" | tee -a "$RESULT_FILE"
        break
    fi
    sleep 1
done

echo "" | tee -a "$RESULT_FILE"

# Memory Usage
echo "=== Memory Usage ===" | tee -a "$RESULT_FILE"
if [ "$PLATFORM" = "vm" ]; then
    vagrant ssh -c "free -h" 2>/dev/null | tee -a "$RESULT_FILE"
elif [ "$PLATFORM" = "docker" ]; then
    docker stats --no-stream flask-blog-benchmark | tee -a "$RESULT_FILE"
fi

echo "" | tee -a "$RESULT_FILE"

# Load Testing
echo "=== Load Testing ===" | tee -a "$RESULT_FILE"
if command -v curl &> /dev/null; then
    echo "Running basic load test with curl..." | tee -a "$RESULT_FILE"
    
    # Response time test
    RESPONSE_TIMES=()
    for i in {1..10}; do
        RESPONSE_TIME=$(curl -o /dev/null -s -w "%{time_total}" "$APP_URL")
        RESPONSE_TIMES+=($RESPONSE_TIME)
        echo "Request $i: ${RESPONSE_TIME}s" | tee -a "$RESULT_FILE"
    done
    
    # Calculate average response time
    TOTAL=0
    for time in "${RESPONSE_TIMES[@]}"; do
        TOTAL=$(echo "$TOTAL + $time" | bc)
    done
    AVERAGE=$(echo "scale=4; $TOTAL / ${#RESPONSE_TIMES[@]}" | bc)
    echo "Average Response Time: ${AVERAGE}s" | tee -a "$RESULT_FILE"
else
    echo "curl not available for load testing" | tee -a "$RESULT_FILE"
fi

echo "" | tee -a "$RESULT_FILE"

# Resource Usage During Load
echo "=== Resource Usage During Load ===" | tee -a "$RESULT_FILE"
if [ "$PLATFORM" = "vm" ]; then
    vagrant ssh -c "top -bn1 | head -20" 2>/dev/null | tee -a "$RESULT_FILE"
elif [ "$PLATFORM" = "docker" ]; then
    docker stats --no-stream flask-blog-benchmark | tee -a "$RESULT_FILE"
fi

# Cleanup
echo "" | tee -a "$RESULT_FILE"
echo "=== Cleanup ===" | tee -a "$RESULT_FILE"
if [ "$PLATFORM" = "docker" ]; then
    docker stop flask-blog-benchmark 2>/dev/null | tee -a "$RESULT_FILE"
    docker rm flask-blog-benchmark 2>/dev/null | tee -a "$RESULT_FILE"
    echo "Docker container cleaned up" | tee -a "$RESULT_FILE"
fi

echo "" | tee -a "$RESULT_FILE"
echo "Benchmark completed. Results saved to: $RESULT_FILE" | tee -a "$RESULT_FILE"
echo "=== End of Benchmark ===" | tee -a "$RESULT_FILE"