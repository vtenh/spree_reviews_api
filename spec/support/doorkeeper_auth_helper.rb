module DoorkeeperAuthHelper
  def create_resource_owner_token
    @oauth_application = create(:oauth_application)
    @oauth_resource_owner = create(:user)
    @oauth_access_token = create(:oauth_access_token,
                                  application: @oauth_application,
                                  resource_owner: @oauth_resource_owner)
    @oauth_access_token
  end

  def create_application_token
    @oauth_application  = create(:oauth_application)
    @oauth_access_token = create(:oauth_access_token, application: @oauth_application)
    @oauth_access_token
  end

  def set_vendor_resoucre_owner_token
    doorkeeper_token = create_resource_owner_token
    vendor = create(:vendor)

    @oauth_resource_owner.vendors = [vendor]
    @oauth_resource_owner.save

    set_header_token(doorkeeper_token.token)
  end

  def set_resource_owner_token
    doorkeeper_token = create_resource_owner_token
    set_header_token(doorkeeper_token.token)
  end

  def set_application_token
    doorkeeper_token = create_application_token
    set_header_token(doorkeeper_token.token)
  end

  def set_header_token(token)
    headers = {
      "Host" => ENV['DEFAULT_URL_HOST'],
      "Accept" => "application/json",
      "Authorization" => "Bearer #{token}"
    }

    headers.each do |key, value|
      @request.headers[key] = value
    end
  end
end

RSpec.configure do |config|
  config.include DoorkeeperAuthHelper, type: :controller
end
