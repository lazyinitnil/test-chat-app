# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.destroy_all
Message.destroy_all

usernames = %w[Alice Bob Carol Dave Eve Frank Grace Henry Ivy Jack Karen Leo]

users = usernames.map do |name|
  user = User.create!(
    username: name,
    password: "password",
    password_confirmation: "password"
  )

  avatar_path = Rails.root.join("app/assets/images/avatars/#{rand(1..12)}.png")
  if File.exist?(avatar_path)
    user.avatar.attach(io: File.open(avatar_path), filename: "#{name.downcase}_avatar.png")
  end

  if rand < 0.2
    user.update!(last_login_at: nil)
  else
    user.update!(last_login_at: rand(1..7).days.ago + rand(0..23).hours + rand(0..59).minutes)
  end

  puts "Создан пользователь #{user.username}"
  user
end

users.each do |sender|
  recipients = users.reject { |u| u == sender }.sample(6)
  recipients.each do |receiver|
    3.times do
      content = ["Привет!", "Как дела?", "Что нового?", "Проверка чата", "Тестовое сообщение"].sample
      Message.create!(
        sender: sender,
        receiver: receiver,
        content: content,
        created_at: rand(1..7).days.ago + rand(0..23).hours + rand(0..59).minutes
      )
    end
  end
end