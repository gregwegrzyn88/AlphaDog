
class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    # If session[userId] is not empty, then try to find User object and set to current_user
    current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    # If the current user exists, then must be logged in
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You must login to perform that action."
      redirect_to root_path
    end
  end
end

