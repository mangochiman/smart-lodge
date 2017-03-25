# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  skip_before_filter :verify_authenticity_token
  # Scrub sensitive parameters from your log
  before_filter :authenticate_user
  filter_parameter_logging :password

  def authenticate_user
    user = User.find(session[:user].user_id) rescue nil
    unless user.blank?
      User.current_user = user
      return true 
    end
    access_denied
    return false
  end

  def access_denied
    redirect_to ("/login") and return
  end

  def check_admin_role
    user = User.find(session[:user].user_id) rescue nil
    unless user.blank?
      user_roles = user.user_roles.collect{|r|r.role}
      return true if user_roles.include?('admin')
      redirect_to ("/dashboard") and return
      return false
    end
  end

  def lock_screen_when_activated
    user = User.find(session[:user].user_id) rescue nil
    if user
      return true if session[:screen_locked].blank?
      redirect_to ("/lock_screen") and return
      return true
    end
  end
  
end
