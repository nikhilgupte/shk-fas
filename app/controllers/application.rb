# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include LoginSystem

  helper :all # include all helpers, all the time
  before_filter :logged_in_user, :except => [:login]
  before_filter :login_required, :except => [:login]
  before_filter :check_permission

  expires_session :time => 20.minutes
  
  filter_parameter_logging :password

  private
  def logged_in_user
    response.headers['Cache-control'] = 'no-cache, no-store'
    if session[:logged_in_user_id]
      @logged_in_user = User.find(session[:logged_in_user_id])
      if @logged_in_user.disabled?
        return render(:template => 'access_denied', :status => :unauthorized)
      end
    end
  end

  def authorize?(user)
    user && !user.disabled?
  end

  def check_permission
    @module = self.controller_path
    if (@operation = Permission.operation(@module, params[:action])) && ! @logged_in_user.is_permitted?(@module, @operation)
      if request.xhr?
        return render(:text => "<b>Access Denied!</b><br />You do not have <b>#{@operation.to_s.humanize.titleize}</b> rights on the <b>#{@module.to_s.humanize.titleize}</b> module.")
      else
        return render(:template => 'access_denied', :status => :unauthorized)
      end
    end
  end

end
