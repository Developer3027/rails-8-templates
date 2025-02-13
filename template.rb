require 'fileutils'

# Modify gitignore and github workflow, add basic tailwind config.
# The added weight of the gem files should not be pushed up to github.
# Fix workflow so initial run does not fail due to ignored folder.

# When cloning the repo, run bundle or bundle install and Rails will review the gem / 
# gem-lock file and install the missing gems. Pushing that weight is not needed.

# This templates will add the lines to the gitignore, cutting the weight of the tracked 
# files, and modify the workflow job - test to ensure the container is set up properly
# and working. Uses PostgreSQL in workflow. 

# NOTE - This will completely rewrite these files.
# NOTE - Default files used with modifications noted.

# Method to write a file, deleting existing file if necessary
def write_file(file_path, content)
  if File.exist?(file_path)
    File.delete(file_path)  # Delete the existing file
  end
  File.open(file_path, 'w') do |file|
    file.write(content)  # Write the new content
  end
end

# Add lines to .gitignore
write_file('.gitignore', <<-CODE
# ignore the gems of bundle
/vendor/bundle

# Ignore bundler config.
/.bundle

# Ignore all environment files.
/.env*

# Ignore all logfiles and tempfiles.
/log/*
/tmp/*
!/log/.keep
!/tmp/.keep

# Ignore pidfiles, but keep the directory.
/tmp/pids/*
!/tmp/pids/
!/tmp/pids/.keep

# Ignore storage (uploaded files in development and any SQLite databases).
/storage/*
!/storage/.keep
/tmp/storage/*
!/tmp/storage/
!/tmp/storage/.keep

/public/assets

# Ignore master key for decrypting credentials and more.
/config/master.key

/app/assets/builds/*
!/app/assets/builds/.keep
CODE
)

# Ensure the workflows directory exists
workflow_dir = '.github/workflows'
FileUtils.mkdir_p(workflow_dir) unless Dir.exist?(workflow_dir)

# Modify the ci.yml file
inside(workflow_dir) do
  write_file('ci.yml', <<-YAML
name: CI

on:
  pull_request:
  push:
    branches: [ main ]

jobs:
  scan_ruby:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: .ruby-version
          bundler-cache: true

      - name: Scan for common Rails security vulnerabilities using static analysis
        run: bin/brakeman --no-pager

  scan_js:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: .ruby-version
          bundler-cache: true

      - name: Scan for security vulnerabilities in JavaScript dependencies
        run: bin/importmap audit

  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: .ruby-version
          bundler-cache: true

      - name: Lint code for consistent style
        run: bin/rubocop -f github

  test:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres
        env:
          POSTGRES_USER: postgres # Default for postgres. Container will be destroyed after run.
          POSTGRES_PASSWORD: postgres # Default for postgres.
        ports:
          - 5432:5432
        options: --health-cmd="pg_isready" --health-interval=10s --health-timeout=5s --health-retries=3

    steps:
      - name: Install packages
        run: sudo apt-get update && sudo apt-get install --no-install-recommends -y google-chrome-stable curl libjemalloc2 libvips postgresql-client

      - name: Checkout code # Grab the code [ package json, gem file, good stuff ]
        uses: actions/checkout@v4

      - name: Set up Ruby # Will run bundle auto on setup I assume because bundler-cache true.
        uses: ruby/setup-ruby@v1Gifs

        with:
          ruby-version: .ruby-version
          bundler-cache: true

      - name: Run tests # Run Rails app tests
        env:
          RAILS_ENV: test
          DATABASE_URL: postgres://postgres:postgres@localhost:5432
        run: 
          bin/rails db:migrate db:test:prepare test test:system

      - name: Keep screenshots from failed system tests
        uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: screenshots
          path: ${{ github.workspace }}/tmp/screenshots
          if-no-files-found: ignore

YAML
  )
end


# Ensure the config directory exists
config_dir = 'config'
FileUtils.mkdir_p(config_dir) unless Dir.exist?(config_dir)

# Create the tailwind.config file
inside(workflow_dir) do
  write_file('tailwind.config', <<-CODE
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    
  ]
}

CODE
)
