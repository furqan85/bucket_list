Rails.application.config.middleware.use OmniAuth::Builder do
  provider :mindvalley, Settings.mindvalley.accounts.key, Settings.mindvalley.accounts.secret
end