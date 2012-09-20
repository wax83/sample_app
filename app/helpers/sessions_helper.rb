module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user# set current_user
  end

  def signed_in?
    !current_user.nil?# returns true if this is true
  end

  def current_user=(user)# setter
    @current_user = user
  end

  def current_user# getter
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
    # no need to hit the db again, if current_user is already set!
  end

  def sign_out
    self.current_user = nil
    cookies.delete :remember_token
  end
end
