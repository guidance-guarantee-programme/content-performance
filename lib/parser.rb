require 'yaml'

class Parser
  attr_accessor :source, :content, :frontmatter
  private :source=, :content=, :frontmatter=

  def initialize(source)
    self.source = source
    parse!
  end

  private

  def parse!
    result = source.match(/(?<frontmatter>^---$.*?^---$\n)?(?<content>.*)/m)
    self.content = result[:content]
    self.frontmatter = YAML.load(result[:frontmatter]) rescue {}
  end
end
