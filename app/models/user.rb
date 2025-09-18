class User < ApplicationRecord
  has_secure_password validations: false
  validates :username, presence: { message: "не может быть пустым" },
            uniqueness: { message: "уже занят" },
            length: { minimum: 2, maximum: 20,
                      too_short: "слишком короткое (мин. %{count} символа)",
                      too_long: "слишком длинное (макс. %{count} символов)" },
            format: { with: /\A[a-zA-Z0-9]+\Z/,
                      message: "может содержать только латинские буквы, цифры и _" }
  validates :password, presence: { message: "не может быть пустым" },
            length: { minimum: 8, maximum: 48,
                      too_short: "слишком короткий (мин. %{count} символов)",
                      too_long: "слишком длинный (макс. %{count} символов)" },
            confirmation: { message: "и подтверждение не совпадают" },
            if: -> { new_record? || !password.nil? }

  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: "receiver_id", dependent: :destroy

  before_create :assign_random_avatar

  def online?
    last_login_at.present? && last_login_at > 3.minutes.ago
  end

  private

  def assign_random_avatar
    avatars = Dir[Rails.root.join("app/assets/images/avatars/*.png")]
    self.avatar = "avatars/#{File.basename(avatars.sample)}"
  end
end
