require_relative 'guide'

require 'oj'
require 'net/https'
require 'uri'

class Github

  CONTENT_REPOSITORY = 'https://api.github.com/repos/guidance-guarantee-programme/pension_guidance/contents/content'.freeze

  private_constant :CONTENT_REPOSITORY

  # Returns guides from content repository
  def self.guides
    guides = []

    uri = URI.parse(CONTENT_REPOSITORY)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    contents = Oj.load(response.body)

    contents.each do |content|
      uri = URI.parse(content['download_url'])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      raw = http.request(request)
      guides << Guide.new(content['name'], raw.body.force_encoding('UTF-8'))
    end

    guides
  end
end
