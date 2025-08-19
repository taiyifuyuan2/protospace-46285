#!/usr/bin/env bash
# exit on error
set -o errexit

# Debug information
echo "=== Build Environment Info ==="
echo "Ruby version: $(ruby --version)"
echo "Bundler version: $(bundle --version)"
echo "Current directory: $(pwd)"
echo "Gemfile contents:"
cat Gemfile

# Install dependencies with verbose output
echo "=== Installing dependencies ==="
bundle install --verbose

# Verify puma is available
echo "=== Verifying puma installation ==="
bundle exec puma --version

# Precompile assets
echo "=== Precompiling assets ==="
bundle exec rake assets:precompile

# Clean assets
echo "=== Cleaning assets ==="
bundle exec rake assets:clean

# Run migrations
echo "=== Running database migrations ==="
bundle exec rake db:migrate

echo "=== Build completed successfully ==="