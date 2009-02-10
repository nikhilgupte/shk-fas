# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include LoginSystem

  helper :all # include all helpers, all the time
  before_filter :logged_in_user, :except => [:login]
  before_filter :login_required, :except => [:login]

  #protect_from_forgery
  
  filter_parameter_logging :password

  private
  def logged_in_user
    if session[:logged_in_user_id]
      @logged_in_user = User.find(session[:logged_in_user_id])
    #else
      #return redirect_to account_path(:action => :login)
    end
  end

  def authorize?(user)
    user && !user.disabled?
  end
end
