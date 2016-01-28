require_relative 'parser'
require 'govspeak'
require 'lingua'

class Guide
  attr_reader :id, :source, :title, :content, :words, :score, :expected_time
  attr_accessor :observed_time

  WORDS_PER_MINUTE = 200.freeze
  WORDS_PER_SECOND = (WORDS_PER_MINUTE / 60.0).freeze
  EXAMPLE_TIME_OVERHEAD = 7.freeze # seconds

  private_constant :WORDS_PER_MINUTE, :WORDS_PER_SECOND, :EXAMPLE_TIME_OVERHEAD

  def initialize(id, source = '')
    @id = id
    @source = source
  end

  def slug
    File.basename(id, '.*').tr('_', '-')
  end

  def title
    @title ||= govspeak.headers.find { |header| header.level == 1 }.text rescue nil
  end

  def content
    @content ||= govspeak.to_text
  end

  def words
    @words ||= readability.num_words
  end

  def examples
    readability.occurrences('Example')
  end

  def links
    @source.scan(/\[.*?\]\(.*?\)/)
  end

  def score
    readability.flesch
  end

  def expected_time
    @expected_time ||= words / WORDS_PER_SECOND + examples * EXAMPLE_TIME_OVERHEAD
  end

  private

  def govspeak
    content = Parser.new(@source).content
    @govspeak ||= Govspeak::Document.new(content)
  end

  def readability
    @readibility ||= Lingua::EN::Readability.new(content)
  end
end
