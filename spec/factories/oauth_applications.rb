
FactoryBot.define do
  factory :oauth_application, class: Doorkeeper::Application do
    sequence(:name) { |n| "Name-#{n}" }
    confidential { true }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
  end
end
