class SessionsController < ApplicationController
  def new
  	session[:return_to] = params[:returnto] unless params[:returnto].nil?
    redirect_to "/auth/mindvalley"
  end

# /auth/mindvalley
  def create
    # Rails.logger.info request.env["omniauth.auth"]
    unless request.env["omniauth.auth"]["credentials"].nil?
      auth_token = request.env["omniauth.auth"]["credentials"]["token"]
      
      user = User.find_or_create_authenticated_user(auth_token)

      if user.present?
        # user.update_purchases!
        # user.update_giftables!
        session[:user_id] = user.id unless user.nil? # user is now logged in
        # KM.record('Signed In')
        redirect_to profile_url(user)
        return
      end
    end
    redirect_to root_url, alert: 'User not found or invalid'
  end

  # /logout
  def destroy
    logout
    # redirect_to root_url, :notice => "You have been logged out."
    
    app_id = Settings.mindvalley.accounts.key
    redirect_to "#{Settings.mindvalley.accounts.api}logout?app_id=#{app_id}"
  end
end
