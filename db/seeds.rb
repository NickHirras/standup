# Clear existing data
puts "Clearing existing data..."
User.destroy_all
Company.destroy_all
Team.destroy_all
Ceremony.destroy_all
Question.destroy_all
Response.destroy_all
ChatIntegration.destroy_all
TeamChatConfig.destroy_all
UserWorkSchedule.destroy_all

# Create a company
puts "Creating company..."
company = Company.create!(
  name: "Acme Corporation",
  domain: "acme.com",
  settings: {
    timezone: "America/Chicago",
    default_work_hours: "9:00 AM - 5:00 PM",
    notification_preferences: {
      email: true,
      chat: true,
      reminder_time: "8:00 AM"
    }
  }.to_json
)

# Create admin user
puts "Creating admin user..."
admin = User.create!(
  email: "admin@acme.com",
  password: "password123",
  password_confirmation: "password123",
  first_name: "Admin",
  last_name: "User",
  role: "admin",
  company: company,
  timezone: "America/Chicago",
  notification_preferences: {
    email: true,
    chat: true,
    reminder_time: "8:00 AM"
  }.to_json
)

# Create regular users
puts "Creating regular users..."
users = []
5.times do |i|
  user = User.create!(
    email: "user#{i + 1}@acme.com",
    password: "password123",
    password_confirmation: "password123",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    role: "user",
    company: company,
    timezone: "America/Chicago",
    notification_preferences: {
      email: true,
      chat: true,
      reminder_time: "8:00 AM"
    }.to_json
  )
  users << user
end

# Create teams
puts "Creating teams..."
teams = []
3.times do |i|
  team = Team.create!(
    name: [ "Engineering", "Product", "Design", "Marketing", "Sales" ][i],
    description: Faker::Company.catch_phrase,
    company: company
  )
  teams << team
end

# Add users to teams
puts "Adding users to teams..."
teams.each_with_index do |team, team_index|
  # Add admin to all teams as manager
  team.add_member(admin, role: 'manager')

  # Add some users to each team
  users_to_add = users.sample(rand(2..4))
  users_to_add.each_with_index do |user, user_index|
    role = user_index == 0 ? 'manager' : 'member'
    team.add_member(user, role: role)
  end
end

# Create ceremonies
puts "Creating ceremonies..."
ceremonies = []
teams.each do |team|
  ceremony = Ceremony.create!(
    name: "#{team.name} Daily Stand-up",
    description: "Daily team check-in to discuss progress, blockers, and plans",
    team: team,
    cadence: "daily",
    scheduled_time: Time.parse("8:00 AM"),
    timezone: "America/Chicago",
    active: true
  )
  ceremonies << ceremony
end

# Create questions for ceremonies
puts "Creating questions..."
question_types = %w[short_answer paragraph multiple_choice checkboxes dropdown linear_scale date time]
ceremonies.each do |ceremony|
  # What did you work on yesterday?
  Question.create!(
    ceremony: ceremony,
    question_text: "What did you work on yesterday?",
    question_type: "paragraph",
    required: true,
    order: 1
  )

  # What are you working on today?
  Question.create!(
    ceremony: ceremony,
    question_text: "What are you working on today?",
    question_type: "paragraph",
    required: true,
    order: 2
  )

  # Any blockers?
  Question.create!(
    ceremony: ceremony,
    question_text: "Do you have any blockers or need help with anything?",
    question_type: "short_answer",
    required: false,
    order: 3
  )

  # How are you feeling?
  Question.create!(
    ceremony: ceremony,
    question_text: "How are you feeling today? (1-5 scale)",
    question_type: "linear_scale",
    required: false,
    order: 4
  )

  # Priority level
  Question.create!(
    ceremony: ceremony,
    question_text: "What's your priority level for today?",
    question_type: "dropdown",
    options: [ "Low", "Medium", "High", "Critical" ].to_json,
    required: true,
    order: 5
  )

  # Team mood
  Question.create!(
    ceremony: ceremony,
    question_text: "How would you describe the team's current mood?",
    question_type: "multiple_choice",
    options: [ "Excited", "Focused", "Stressed", "Relaxed", "Challenged" ].to_json,
    required: false,
    order: 6
  )

  # Work environment
  Question.create!(
    ceremony: ceremony,
    question_text: "What best describes your current work environment?",
    question_type: "checkboxes",
    options: [ "Quiet", "Collaborative", "Distracting", "Productive", "Flexible" ].to_json,
    required: false,
    order: 7
  )
end

# Create some sample responses
puts "Creating sample responses..."
ceremonies.each do |ceremony|
  ceremony.team.users.each do |user|
    ceremony.questions.each do |question|
      next if rand > 0.7 # 70% chance of responding

      answer = case question.question_type
      when "paragraph"
        Faker::Lorem.paragraph(sentence_count: 2)
      when "short_answer"
        Faker::Lorem.sentence
      when "multiple_choice"
        question.options_array.sample
      when "checkboxes"
        question.options_array.sample(rand(1..2)).to_json
      when "dropdown"
        question.options_array.sample
      when "linear_scale"
        rand(1..5).to_s
      when "date"
        Date.current.to_s
      when "time"
        Time.current.strftime("%H:%M")
      else
        "Sample response"
      end

      Response.create!(
        ceremony: ceremony,
        user: user,
        question: question,
        answer: answer,
        submitted_at: Time.current - rand(0..23).hours
      )
    end
  end
end

# Create work schedules for users
puts "Creating work schedules..."
users.each do |user|
  UserWorkSchedule.create!(
    user: user,
    start_time: Time.parse("9:00 AM"),
    end_time: Time.parse("5:00 PM"),
    timezone: "America/Chicago",
    days_of_week: [ 1, 2, 3, 4, 5 ].to_json # Monday to Friday
  )
end

# Create admin work schedule
UserWorkSchedule.create!(
  user: admin,
  start_time: Time.parse("8:00 AM"),
  end_time: Time.parse("6:00 PM"),
  timezone: "America/Chicago",
  days_of_week: [ 1, 2, 3, 4, 5 ].to_json
)

# Create chat integrations
puts "Creating chat integrations..."
slack_integration = ChatIntegration.create!(
  company: company,
  platform: "slack",
  config: {
    bot_token: "xoxb-sample-token",
    app_token: "xapp-sample-token",
    signing_secret: "sample-secret"
  }.to_json,
  active: true
)

google_chat_integration = ChatIntegration.create!(
  company: company,
  platform: "google_chat",
  config: {
    service_account_key: "sample-service-account-key",
    project_id: "sample-project-id"
  }.to_json,
  active: false
)

# Create team chat configs
puts "Creating team chat configs..."
teams.each do |team|
  TeamChatConfig.create!(
    team: team,
    chat_integration: slack_integration,
    chat_space_id: "C#{rand(1000000..9999999)}",
    chat_space_name: "#{team.name.downcase}-standup",
    active: true
  )
end

puts "Seed data created successfully!"
puts "Admin user: admin@acme.com / password123"
puts "Regular users: user1@acme.com through user5@acme.com / password123"
puts "Company: #{company.name}"
puts "Teams: #{teams.map(&:name).join(', ')}"
puts "Ceremonies: #{ceremonies.count} created"
puts "Questions: #{Question.count} created"
puts "Responses: #{Response.count} created"
