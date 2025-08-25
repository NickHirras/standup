# Standup - Virtual Daily Stand-ups for Teams

A modern, beautiful web application for software development teams to conduct virtual daily stand-ups and team ceremonies. Built with Rails 8 and inspired by the clean design principles of Tailwind css.

## Features

### 🏢 **Company & Team Management**
- Multi-company support with isolated teams
- Role-based access control (Admin, Team Manager, Team Member)
- Flexible team structures with managers and members

### 📅 **Ceremony Management**
- Create custom ceremonies with flexible scheduling (daily, weekly, bi-weekly, monthly)
- Support for multiple question types:
  - Short Answer & Paragraph
  - Multiple Choice & Checkboxes
  - Dropdown Lists
  - Linear Scales
  - Date & Time
  - File Uploads
  - Grid-based questions

### 💬 **Chat Integration**
- Slack integration
- Google Chat integration
- Microsoft Teams integration
- Configurable notification channels per team
- Automated reminders and updates

### ⏰ **Smart Scheduling**
- Individual work hour configuration
- Timezone-aware scheduling
- Customizable notification preferences
- Work day configuration (Monday-Sunday)

### 📊 **Analytics & Insights**
- Team participation tracking
- Response completion rates
- Historical response data
- Individual and team performance metrics

## Technology Stack

- **Backend**: Ruby on Rails 8
- **Database**: SQLite (easily configurable for PostgreSQL/MySQL)
- **Authentication**: Devise
- **Authorization**: Pundit
- **Styling**: Tailwind CSS
- **Frontend**: Hotwire (Turbo + Stimulus)
- **Background Jobs**: Sidekiq
- **Chat Integrations**: Slack, Google Chat, Microsoft Teams APIs
- **Development Environment**: Dev Container with Docker (VS Code)

## Screenshots

<img width="1412" height="973" alt="image" src="https://github.com/user-attachments/assets/9b44d1bb-b93c-4d9b-a826-815c709e3b88" />

<img width="1412" height="973" alt="image" src="https://github.com/user-attachments/assets/806fd6c0-7e6c-41ee-b4f0-ad3fc645c15d" />


## Getting Started

> **🚀 Quick Start**: For the fastest setup, jump to [Development with Dev Container](#-development-with-dev-container-recommended) below!

### Prerequisites
- Ruby 3.4+
- Rails 8.0+
- SQLite3

## 🐳 Development with Dev Container (Recommended)

The easiest way to get started with development is using VS Code's Dev Container feature. This provides a consistent, isolated development environment with all dependencies pre-configured.

### Prerequisites for Dev Container
- [VS Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (or Docker Engine)

### Quick Start with Dev Container

1. **Clone and Open**
   ```bash
   git clone <repository-url>
   cd standup
   code .
   ```

2. **Open in Container**
   - When VS Code opens, click **"Reopen in Container"** when prompted
   - Or use `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"

3. **Automatic Setup**
   The container will automatically:
   - Install Ruby gems (`bundle install`)
   - Install Node.js packages (`npm install`)
   - Create and migrate the database
   - Seed sample data
   - Start the Rails server

4. **Access Your App**
   - Rails server: http://localhost:3000
   - Redis: localhost:6379 (for Sidekiq)

### What's Included in the Dev Container

- **Ruby 3.4.5** with all development gems
- **Node.js 20** for Tailwind CSS compilation
- **SQLite3** database
- **Redis** for Sidekiq background jobs
- **Development Tools**: RuboCop, Solargraph, debugging support
- **VS Code Extensions**: Ruby support, Tailwind CSS IntelliSense, ERB templates

### Dev Container Features

- **Automatic Port Forwarding**: Rails (3000) and Redis (6379)
- **Persistent Volumes**: Bundle cache, node modules, and database files
- **Hot Reload**: Changes to your code are reflected immediately
- **Integrated Terminal**: Full access to the container environment
- **Debugging**: Ruby debugging support with breakpoints

### Working with the Dev Container

```bash
# The container provides these commands automatically:
bundle exec rails server          # Start Rails server
bundle exec rails console        # Rails console
bundle exec rails test           # Run tests
bundle exec rubocop              # Code linting
bundle exec sidekiq              # Background job processing
npm run build:css                # Compile Tailwind CSS
```

### Troubleshooting Dev Container

- **Port Conflicts**: Ensure ports 3000 and 6379 are available
- **Permission Issues**: The container runs as non-root user `vscode`
- **Database Issues**: Check that the `storage/` directory is properly mounted
- **Rebuild Container**: Use `Ctrl+Shift+P` → "Dev Containers: Rebuild Container"

For more details, see [`.devcontainer/README.md`](.devcontainer/README.md).

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd standup
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the application**
   ```bash
   bin/dev
   ```

5. **Access the application**
   Navigate to `http://localhost:3000`

### Default Credentials

After running the seeds, you can log in with:

- **Admin User**: `admin@acme.com` / `password123`
- **Regular Users**: `user1@acme.com` through `user5@acme.com` / `password123`

## Usage

### For Administrators
1. **Company Setup**: Configure company settings and integrations
2. **User Management**: Create and manage user accounts
3. **Chat Integrations**: Set up Slack, Google Chat, or Microsoft Teams connections
4. **Team Oversight**: Monitor all teams and their activities

### For Team Managers
1. **Team Creation**: Create and manage teams
2. **Member Management**: Add/remove team members and assign roles
3. **Ceremony Setup**: Create and configure team ceremonies
4. **Question Design**: Design custom questions for team check-ins
5. **Response Monitoring**: Track team participation and responses

### For Team Members
1. **Daily Check-ins**: Participate in scheduled ceremonies
2. **Work Schedule**: Configure personal work hours and availability
3. **Team Collaboration**: View team responses and updates
4. **Personal Dashboard**: Track your participation and history

## Configuration

### Environment Variables
Create a `.env` file in the root directory:

```bash
# Database
DATABASE_URL=sqlite3:db/development.sqlite3

# Chat Integration Tokens
SLACK_BOT_TOKEN=your_slack_bot_token
GOOGLE_CHAT_CREDENTIALS=path_to_service_account.json
MICROSOFT_TEAMS_CLIENT_ID=your_client_id
MICROSOFT_TEAMS_CLIENT_SECRET=your_client_secret

# Application
RAILS_ENV=development
SECRET_KEY_BASE=your_secret_key_base
```

### Chat Integration Setup

#### Slack
1. Create a Slack app in your workspace
2. Add bot token scopes for messaging
3. Configure the bot token in the admin panel

#### Google Chat
1. Enable Google Chat API
2. Create a service account
3. Download the JSON credentials file
4. Upload and configure in the admin panel

#### Microsoft Teams
1. Register an application in Azure AD
2. Configure permissions for Microsoft Graph
3. Add client ID and secret in the admin panel

## Development

### Running Tests
```bash
rails test
```

### Code Quality
```bash
bundle exec rubocop
```

### Database Console
```bash
rails console
```

## Deployment

The application includes Kamal deployment configuration for easy deployment to various hosting providers.

```bash
kamal deploy
```

## Contributing

We welcome contributions! For the best development experience, we recommend using the Dev Container setup.

### Development Setup

1. **Use Dev Container** (Recommended)
   - Follow the [Dev Container setup](#-development-with-dev-container-recommended) above
   - This ensures a consistent development environment

2. **Traditional Setup** (Alternative)
   - Follow the [Installation](#installation) steps below
   - Ensure you have all prerequisites installed locally

### Contributing Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for new functionality
5. Run the test suite (`bundle exec rails test`)
6. Check code quality (`bundle exec rubocop`)
7. Commit your changes (`git commit -m 'Add amazing feature'`)
8. Push to the branch (`git push origin feature/amazing-feature`)
9. Submit a pull request

### Code Quality Standards

- Follow Rails conventions and best practices
- Ensure all tests pass
- Run RuboCop and fix any linting issues
- Add appropriate documentation for new features
- Follow the existing code style and patterns

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the GitHub repository or contact the development team.

---

Built with ❤️ for modern development teams who value beautiful, functional software.
