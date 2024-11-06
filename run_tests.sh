#!/bin/bash

# Get environment as the first argument (alpha, beta, prod)
ENVIRONMENT=$1

echo "Running ProTI tests for environment: $ENVIRONMENT"

# Define the directory containing ProTI test cases (assuming a structured directory layout)
TEST_DIR="${ENVIRONMENT}/proti_tests"

# Exit if TEST_DIR does not exist
if [ ! -d "$TEST_DIR" ]; then
  echo "ERROR: Test directory $TEST_DIR does not exist."
  exit 1
fi

# Example: Run setup steps for testing, such as verifying target resource availability
# You can include connectivity tests or other basic checks here as needed.
echo "Verifying connectivity to required services..."

# Check if a target resource (e.g., a server or database) is reachable
TARGET_SERVER="target_server_ip_or_hostname"  # Replace with actual target server
if nc -z -w 5 $TARGET_SERVER 80; then
  echo "Target server is reachable on port 80"
else
  echo "ERROR: Target server is not reachable on port 80"
  exit 1
fi

# Now, run ProTI tests in the specified test directory
echo "Running ProTI tests in $TEST_DIR..."
cd "$TEST_DIR" || exit

# Run all ProTI tests (assuming these are executable scripts or commands in the directory)
for test_file in *.pti; do
  if [ -f "$test_file" ]; then
    echo "Running ProTI test: $test_file"
    # Example command for running ProTI test (replace with actual ProTI execution command)
    ./proti_exec "$test_file" || { echo "ERROR: Test $test_file failed"; exit 1; }
  fi
done

echo "All ProTI tests completed successfully for environment: $ENVIRONMENT"
exit 0
