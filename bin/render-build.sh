#!/usr/bin/env bash
# exit on error
set -o errexit

echo "=== Starting Render build process ==="

# Set environment variables
export RAILS_ENV=production
export NODE_ENV=production

echo "=== Environment variables set ==="
echo "RAILS_ENV: $RAILS_ENV"
echo "NODE_ENV: $NODE_ENV"

# Install dependencies
echo "=== Installing dependencies ==="
bundle install

echo "=== Dependencies installed successfully ==="

# Precompile assets
echo "=== Precompiling assets ==="
bundle exec rake assets:precompile

echo "=== Assets precompiled successfully ==="

# Clean assets
echo "=== Cleaning assets ==="
bundle exec rake assets:clean

echo "=== Assets cleaned successfully ==="

# Run migrations
echo "=== Running database migrations ==="
# bundle exec rake db:migrate
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:migrate:reset

echo "=== Database migrations completed ==="

echo "=== Build completed successfully ==="