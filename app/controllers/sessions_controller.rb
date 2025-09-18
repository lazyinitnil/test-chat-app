class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      user.update(last_login_at: Time.current)
      session[:user_id] = user.id
      redirect_to users_path, notice: "Вход выполнен"
    else
      flash.now[:alert] = "Неверный логин или пароль"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Вы вышли"
  end
end
