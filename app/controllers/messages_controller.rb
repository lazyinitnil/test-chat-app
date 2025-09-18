class MessagesController < ApplicationController
  before_action :require_login

  def index
    @other = User.find(params[:user_id])
    @messages = Message.between(current_user.id, @other.id)
    @message = Message.new(reply_to_id: params[:reply_to])
  end

  def create
    @other = User.find(params[:user_id])
    @message = current_user.sent_messages.build(message_params)
    @message.receiver = @other
    if @message.save
      redirect_to user_messages_path(@other)
    else
      @messages = Message.between(current_user.id, @other.id)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :reply_to_id, :file)
  end
end
