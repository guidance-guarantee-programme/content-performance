require 'google/api_client'

class Gooogle

  APPLICATION_NAME = 'Pension-Wiser'
  APPLICATION_VERSION = 1.0

  API_NAME = ''
  API_VERSION = ''
  API_SCOPE = ''
  API_CACHE = ''

  def initialize
    @client = Google::APIClient.new(:application_name => APPLICATION_NAME, :application_version => APPLICATION_VERSION)

    # Load credentials for the service account
    key = Google::APIClient::KeyUtils.load_from_pkcs12(ENV['GOOGLE_KEY_FILE'], ENV['GOOGLE_KEY_SECRET'])

    @client.authorization = Signet::OAuth2::Client.new(
        :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
        :audience => 'https://accounts.google.com/o/oauth2/token',
        :scope => self.class::API_SCOPE,
        :issuer => ENV['GOOGLE_SERVICE_ACCOUNT'],
        :signing_key => key)

    # Request a token for our service account
    @client.authorization.fetch_access_token!

    # Load cached analytics API
    @api = load_cached_api
  end

  private

  # Load cached discovered analytics API, if it exists. This prevents retrieving the
  # discovery document on every run, saving a round-trip to the discovery service.
  def load_cached_api
    api = nil

    if File.exists?(self.class::API_CACHE)
      File.open(self.class::API_CACHE) do |file|
        api = Marshal.load(file)
      end
    else
      api = @client.discovered_api(self.class::API_NAME, self.class::API_VERSION)
      File.open(self.class::API_CACHE, 'w') do |file|
        Marshal.dump(api, file)
      end
    end

    api
  end
end
