class Admin::UsersController < ApplicationController
  def new
    @user = User.new
    @title = 'Create New User'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'User created.'
      return redirect_to admin_user_path(@user)
    end
    @title = 'Create New User'
    render :action => :new
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

  def modify_permissions
    @user = User.find params[:id]
    unless @user == @logged_in_user
      @user.permissions.delete_all
      if params[:permissions]
        params[:permissions].each do |mod, operations|
          operations.keys.each{|op| @user.permissions.create(:module => mod, :operation => op)}
        end
      end
      flash[:notice] = 'Permissions updated.'
    else
      flash[:notice] = 'You cannot update your own permissions.'
    end
    redirect_to admin_user_path(@user)
  end

  def toggle_disable
    @user = User.find params[:id]
    unless @user == @logged_in_user
      @user.toggle! :disabled
      flash[:notice] = "User account #{@user.disabled? ? 'disabled':'enabled'}."
    else
      flash[:notice] = "You cannot disable your own account."
    end
    render :update do |p|
      p.redirect_to admin_user_path(@user)
    end
  end
end
