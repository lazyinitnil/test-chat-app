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

usernames = %w[Alice Bob Carol Dave Eve Frank Grace Henry Ivy Jack Karen Leo]

usernames.each do |name|
  user = User.create!(
    username: name,
    password: "password",
    password_confirmation: "passwords"
  )

  avatar_path = Rails.root.join("app/assets/images/avatars/#{rand(1..12)}.png")
  if File.exist?(avatar_path)
    user.avatar.attach(io: File.open(avatar_path), filename: "#{name.downcase}_avatar.png")
  end

  puts "Создан пользователь #{user.username}"
end
