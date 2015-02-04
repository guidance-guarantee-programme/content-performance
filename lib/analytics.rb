require_relative 'gooogle'

class Analytics < Gooogle

  API_NAME = 'analytics'
  API_VERSION = 'v3'
  API_SCOPE = 'https://www.googleapis.com/auth/analytics.readonly'
  API_CACHE = 'tmp/analytics.cache'

  # Queries google for a set of analytics metrics
  #
  # Query parameters summary: https://developers.google.com/analytics/devguides/reporting/core/v3/reference#q_summary
  # Dimensions and metrics reference: https://developers.google.com/analytics/devguides/reporting/core/dimsmets
  def query(dimension, metric, sort, start_date, end_date)
    @client.execute(:api_method => @api.data.ga.get,
                    :parameters => {
                        'ids' => "ga:" + ENV['GOOGLE_PROFILE_ID'],
                        'start-date' => start_date,
                        'end-date' => end_date,
                        'dimensions' => dimension,
                        'metrics' => metric,
                        'sort' => sort })
  end

end
