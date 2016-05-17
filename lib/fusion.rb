require_relative 'gooogle'

require 'active_support/core_ext/string'

class Fusion < Gooogle

  API_NAME = 'fusiontables'
  API_VERSION = 'v1'
  API_SCOPE = 'https://www.googleapis.com/auth/fusiontables'
  API_CACHE = 'tmp/fusion.cache'

  def initialize(table_id)
    @table_id = table_id
    super()
  end

  def write(data)
    @client.execute(:api_method => @api.table.import_rows,
                    :parameters => { 'tableId' => @table_id, 'uploadType' => 'media' },
                    :headers => {'Content-Type' => 'application/octet-stream'},
                    :body => data)
  end

  def read
    sql = <<-SQL.strip_heredoc
      SELECT Title, URL, Words, 'Reading Score (Flesch-Kincaid)', 'Expected Time (secs)', 'Observed Time (secs)', 'Unique Pageviews', Date
      FROM #{@table_id}
      ORDER BY Date
    SQL

    @client.execute(:api_method => @api.query.sql_get,
                    :parameters => { 'sql' => sql })
  end
end
