class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :reply_to, class_name: "Message", optional: true
  has_many :replies, class_name: "Message", foreign_key: :reply_to_id

  has_one_attached :file

  validates :content, presence: { message: "не может быть пустым" }, unless: -> { file.attached? },
            length: { minimum: 1, maximum: 1024,
                      too_short: "слишком короткое (мин. %{count} символ)",
                      too_long: "слишком длинное (макс. %{count} символов)", }

  scope :between, ->(a_id, b_id) {
    where(sender_id: [a_id, b_id], receiver_id: [a_id, b_id]).order(:created_at)
  }
end
