require 'sinatra/base'
require 'sinatra/reloader'
require 'csv'
require 'yaml'

require_relative 'lib/fusion'

class PensionWiser < Sinatra::Base

  configure do
    set :tables, YAML.load_file('config/tables.yml')
  end

  configure :development do
    require 'dotenv'
    Dotenv.load

    register Sinatra::Reloader
  end

  get '/' do
    erb :dashboard
  end

  get '/data' do
    content_type 'application/csv'

    table = settings.tables['PensionWiseContent']['id']
    results = Fusion.new(table).read

    CSV.generate do |csv|
      # csv << results.data.columns
      csv << ['title', 'url', 'words', 'score', 'expected', 'observed', 'pageviews', 'date']
      results.data.rows.each { |row| csv << row }
    end
  end
end
