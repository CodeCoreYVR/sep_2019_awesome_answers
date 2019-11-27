Rails.application.config.middleware.use OmniAuth::Builder do
  # To get a Github ID and a GITHUB_SECRET, you must create
  # a Github Developer Application. You can do this in
  # Settings > Developer > Omniauth Applications.
  # This is the same process you will have to do with
  # nearly every provider.
  # provider( :github,
  #         Rails.application.credentials.dig(:github, :client_id),
  #         Rails.application.credentials.dig(:github, :client_secret),
  #         scope: "read:user,user:email")


          provider(:github,
          Rails.application.credentials.dig(:github, :client_id),
          Rails.application.credentials.dig(:github, :client_secret),
          scope: "read:user,user:email")
end
