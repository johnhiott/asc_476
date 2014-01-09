class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_to applicants_path
    else
      flash.now[:error] = 'Invalid email/password'
      render :new
    end
  end

  def destroy
    current_user.delete_remember_token
  end
end
