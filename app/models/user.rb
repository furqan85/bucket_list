class User < ActiveRecord::Base
  attr_accessible :authentication_token, :email, :first_name, :last_name, :provider, :uid
end
