# Dev Container for Standup Rails App

This devcontainer provides a complete development environment for the Standup Rails application.

## What's Included

- **Ruby 3.4.5** - Latest stable Ruby version
- **Rails 8** - Modern Rails framework
- **Node.js 20** - For Tailwind CSS compilation
- **SQLite3** - Database for development
- **Redis** - For Sidekiq background jobs
- **Development Tools** - RuboCop, Solargraph, and more

## Getting Started

1. **Install VS Code** with the Dev Containers extension
2. **Open the project** in VS Code
3. **Click "Reopen in Container"** when prompted
4. **Wait for setup** - the container will install dependencies automatically

## What Happens Automatically

- Ruby gems are installed via `bundle install`
- Node.js packages are installed via `npm install`
- Database is created and migrated
- Sample data is seeded
- Rails server starts on port 3000

## Services

- **Rails App**: http://localhost:3000
- **Redis**: localhost:6379 (for Sidekiq)

## Development Workflow

1. **Start the server**: The Rails server starts automatically
2. **View logs**: Check the terminal for Rails logs
3. **Database**: SQLite files are stored in `storage/` directory
4. **Assets**: Tailwind CSS is compiled automatically

## Useful Commands

```bash
# Run tests
bundle exec rails test

# Run RuboCop
bundle exec rubocop

# Generate new model/controller
bundle exec rails generate model User name:string email:string

# Run migrations
bundle exec rails db:migrate

# Start console
bundle exec rails console

# Start Sidekiq (in separate terminal)
bundle exec sidekiq
```

## Troubleshooting

- **Port conflicts**: Ensure ports 3000 and 6379 are available
- **Permission issues**: The container runs as non-root user `vscode`
- **Database issues**: Check that the `storage/` directory is properly mounted

## Extensions

The following VS Code extensions are automatically installed:
- Ruby language support
- Solargraph (Ruby LSP)
- RuboCop linting
- Tailwind CSS IntelliSense
- ERB template support

## Environment Variables

Key environment variables are set in `.devcontainer/environment.dev`:
- `RAILS_ENV=development`
- `REDIS_URL=redis://redis:6379`
- `DATABASE_URL=sqlite3:/workspace/storage/development.sqlite3`

## Volumes

- **Bundle cache**: Persistent gem installation cache
- **Node modules cache**: Persistent npm package cache
- **Redis data**: Persistent Redis data
- **Workspace**: Your code is mounted at `/workspace`
