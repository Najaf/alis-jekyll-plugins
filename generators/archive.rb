module NajafAliGenerators

  class ArchivePage < Jekyll::Page
    def initialize(site, posts, periods)
      @layout = 'archive'
      @site = site
      @posts = posts
      @dir = ''
      @name = 'archive.html'
      @url = @name
      @periods = periods
      halt_on_layout_error unless layout_available?
    end

    def to_liquid
      data
    end

    def read_yaml(base, name)
      # do nothing
    end

    def data
      {
        "layout" => @layout,
        "posts" => @posts,
        "url" => @url,
        "periods" => @periods
      }
    end

    def layout_available?
      @site.layouts.include? @layout
    end

    def halt_on_layout_error
      $stderr.puts "Layout Unavailable!"
      exit(-1)
    end

  end

  class ArchiveGenerator < Jekyll::Generator

    def initialize(config = {})
      super(config)
    end

    def generate(site)
      posts_by_period = []
      periods = []

      site.posts.uniq.each do |post|
        periods << post.date.strftime("%B %Y")
      end

      posts_by_period = periods.uniq!.reverse!.map do |period|
        site.posts.uniq.select {|post| post.date.strftime("%B %Y") == period }.reverse
      end

      site.pages << ArchivePage.new(site, posts_by_period, periods)

    end
  end
end
