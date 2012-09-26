module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user # set current_user
  end

  def signed_in?
    !current_user.nil? # current_user not nil?
  end

  def current_user=(user) # setter
    @current_user = user
  end

  def current_user # getter
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user # gets & compares current_user
  end

  def sign_out
    self.current_user = nil
    cookies.delete :remember_token
    session[:return_to] = nil
  end

  def store_location
    session[:return_to] = request.fullpath
    # the request object stores all requests
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
  end
end
