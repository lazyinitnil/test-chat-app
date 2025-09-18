module ChatHelper
  def formatted_time(message)
    message.created_at.strftime("%d.%m.%Y %H:%M")
  end
end
