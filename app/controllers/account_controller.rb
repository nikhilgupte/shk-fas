class AccountController < ApplicationController
  def login
    @title = 'Login'
    if request.post?
      begin
        @logged_in_user = User.login(params[:username], params[:password])
        session[:logged_in_user_id] = @logged_in_user.id
        redirect_back_or_default '/'
      rescue
        flash.now[:error] = $!.to_s
      end
    end
  end

  def logout
    reset_session
    flash[:notice] = 'You have successfully logged-out of the system'
    redirect_to account_path(:action => :login)
  end

  def change_password
    @user = @logged_in_user
    @title = "Change Password"
    if request.post?
      if @user.password_valid?(params[:current_password])
        @user.update_attributes(params[:user])
      else
        @user.errors.add_to_base('Invalid current password')
      end
      flash.now[:notice] = 'Password changed' if @user.errors.empty?
    end
  end

end
