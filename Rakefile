require_relative 'lib/analytics'
require_relative 'lib/fusion'
require_relative 'lib/github'

require 'csv'
require 'yaml'

unless ENV['RACK_ENV'] == 'production'
  require 'dotenv'
  Dotenv.load
end

desc 'Collect data for guides'

task :collect do
  guides = []

  # Get guides from GitHub
  guides = Github.guides

  # Get pageviews and average time on page from Google Analytics
  analytics = Analytics.new
  queries = YAML.load_file('config/queries.yml')
  query = queries['UniquePageViews']

  yesterday = ENV.fetch('PROCESS_DATE', Date.today.prev_day.strftime('%Y-%m-%d'))
  results = analytics.query(query['dimension'], query['metric'], query['sort'], yesterday, yesterday)

  # {slug: { path: '/url', upv: 1, time: 2 }}
  ga = Hash.new
  results.data.rows.map do |row|
    slug = row.first[1..-1]
    ga[slug] = { path: row[0], upv: row[1], time: row[2] } unless slug.empty?
  end

  # [Title, URL, Words, Examples, Links, Reading Score, Expected Time, Observed Time, Unique Pageviews, Date]
  data = CSV.generate do |csv|
    guides.each do |guide|
      if ga.key? guide.slug
        title     = guide.title
        url       = ga[guide.slug][:path]
        words     = guide.words
        examples  = guide.examples
        links     = guide.links.count
        score     = guide.score
        expected  = guide.expected_time
        observed  = ga[guide.slug][:time]
        pageviews = ga[guide.slug][:upv]

        csv << [title, url, words, examples, links, score, expected, observed, pageviews, yesterday]
      end
    end
  end

  # Write data to Google Fusion Pension Wise Content table
  tables = YAML.load_file('config/tables.yml')
  table = tables['PensionWiseContent']
  Fusion.new(table['id']).write(data)
end
