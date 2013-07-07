require 'httparty'

module Mindvalley
  class Account
    include HTTParty

    def self.get_user(token)
      url = [server, "me", Account.auth(token)].join
      # binding.pry
      hash = JSON.parse(HTTParty.get(url).to_json)
      hash["user"]
    rescue Exception => e
      Rails.logger.error 'Exception intercepted calling Accounts#get_user'
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      return nil
    end

    private
    def self.auth(token)
      "?access_token=#{token}"
    end
    
    def self.server
      Settings.mindvalley.accounts.api
    end
  end
end
