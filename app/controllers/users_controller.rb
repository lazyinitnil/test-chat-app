class UsersController < ApplicationController
  before_action :require_login, only: [ :index,  :destroy_account]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to users_path, notice: "Аккаунт создан"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @users = User.where.not(id: current_user.id)
  end

  def destroy_account
    @user = User.find(params[:id])
    if @user == current_user
      @user.destroy
      reset_session
      redirect_to signup_path, notice: "Ваш аккаунт удалён."
    else
      redirect_to users_path, alert: "Вы не можете удалить чужой аккаунт!"
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

end
