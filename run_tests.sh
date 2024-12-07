#!/bin/bash
set -e

echo "Running Terraform tests..."
cd tests

# Run Terratest
go test -v ./node_groups_test.go
