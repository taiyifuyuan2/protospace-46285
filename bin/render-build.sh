#!/usr/bin/env bash
# exit on error
set -o errexit

# Enable verbose output
set -x

# Debug information
echo "=== Build Environment Info ==="
echo "Ruby version: $(ruby --version)"
echo "Bundler version: $(bundle --version)"
echo "Current directory: $(pwd)"
echo "Gemfile contents:"
cat Gemfile
echo "=== End Gemfile ==="

# Check if bundle is available
echo "=== Checking bundle availability ==="
which bundle
bundle --version

# Install dependencies with verbose output
echo "=== Installing dependencies ==="
if ! bundle install --verbose; then
    echo "ERROR: bundle install failed"
    echo "=== Bundle install error details ==="
    bundle install --verbose 2>&1
    exit 1
fi

# List installed gems
echo "=== Installed gems ==="
bundle list | grep puma

# Verify puma is available
echo "=== Verifying puma installation ==="
if ! bundle exec puma --version; then
    echo "ERROR: puma not found or not executable"
    echo "=== Puma verification failed ==="
    bundle exec puma --version 2>&1
    exit 1
fi

# Check puma executable path
echo "=== Puma executable path ==="
which puma
bundle exec which puma

# Precompile assets
echo "=== Precompiling assets ==="
if ! bundle exec rake assets:precompile; then
    echo "ERROR: assets precompilation failed"
    exit 1
fi

# Clean assets
echo "=== Cleaning assets ==="
if ! bundle exec rake assets:clean; then
    echo "ERROR: assets cleanup failed"
    exit 1
fi

# Run migrations
echo "=== Running database migrations ==="
if ! bundle exec rake db:migrate; then
    echo "ERROR: database migration failed"
    exit 1
fi

echo "=== Build completed successfully ==="