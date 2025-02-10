#!/bin/bash

# Exit on error
set -e

# Clean project
echo "Cleaning project..."
flutter clean
rm -rf coverage/

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Create coverage directory
mkdir -p coverage

# Run build_runner
echo "Running build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
echo "Running web tests..."
flutter test -d chrome --coverage

# Generate coverage report
echo "Generating coverage report..."
if ! command -v genhtml &> /dev/null; then
  echo "lcov not found. Please install:"
  echo "  Ubuntu: sudo apt-get install lcov"
  echo "  macOS: brew install lcov"
  exit 1
fi

lcov --remove coverage/lcov.info 'lib/firebase_options.dart' -o coverage/new_lcov.info
genhtml coverage/new_lcov.info -o coverage/html

# Generate badge
COVERAGE=$(lcov --summary coverage/new_lcov.info | grep "lines" | cut -d ' ' -f 4 | cut -d '%' -f 1)
echo "<div class='coverage-badge' style='float: right'>Coverage: ${COVERAGE}%</div>" > coverage/html/badge.html

echo "Coverage report generated at coverage/html/index.html" 
