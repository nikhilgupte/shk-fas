# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :auto_login

  #protect_from_forgery
  
  filter_parameter_logging :password

  private
  def auto_login
    @logged_in_user = User.find(1)
  end
end
