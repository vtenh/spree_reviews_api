FactoryBot.define do
  factory :oauth_access_token, class: Spree::OauthAccessToken do
    sequence(:token) { |n| "token-#{n}" }

    # application and resource_owner must be explicitly specified
    # association :application, factory: :oauth_application
    # association :resource_owner, factory: :user
  end
end
