class Admin::UsersController < ApplicationController
  def new
    @user = User.new
  end

  def edit
    @user = User.find params[:id]
    @title = "Edit User: #{@user.username}"
  end

  def update
    @user = User.find params[:id]
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    if @user.update_attributes params[:user]
      flash[:notice] = 'User updated.'
      redirect_to admin_user_path(@user)
    else
      render :action => :edit
    end
  end

  def show
    @user = User.find params[:id]
    @title = "User: #{@user.username}"
  end

end
