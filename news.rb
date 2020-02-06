class News 
  attr_reader :url, :title, :body, :dateScraper, :md5

    def initialize(url, title, body, dateScraper, md5) 
      @url = url
      @title = title
      @body = body
      @dateScraper = dateScraper 
      @md5 = md5
    end
end