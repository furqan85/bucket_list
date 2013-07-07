class User < ActiveRecord::Base
  attr_accessible :authentication_token, :email, :first_name, :last_name, :provider, :uid

	def name
    "#{first_name} #{last_name}"
  end

	def self.find_or_create_authenticated_user(auth_token)
    user = User.find_or_initialize_authenticated_user(auth_token)
    return nil if user.nil?

    user.authentication_token = auth_token

    user.save! if user.changed?
    user
  end

  def self.find_or_initialize_authenticated_user(auth_token)
    hash = Mindvalley::Account.get_user(auth_token)
    return nil if hash.nil?

    begin
      user = User.find_or_initialize_by_uid(:uid => hash["id"])
        # user.update_attributes(hash.reject { |k,v| k == "id"})
      user.attributes = {
        :first_name => hash["info"]['first_name'],
        :last_name => hash["info"]['last_name'],
        :email => hash['email']
      }
      user
    rescue => e
      Rails.logger.error("Account has missing credentials")
      Rails.logger.error(hash.to_yaml)
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      raise MissingUserData, "Account #{hash['email']} is missing credentials"
    end
  end
end
