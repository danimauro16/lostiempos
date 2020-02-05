class News 
  attr_reader :uri, :title, :body, :dateScraper, :md5

    def initialize(uri, title, body, dateScraper, md5) 
      @uri = uri
      @title = title
      @body = body
      @dateScraper = dateScraper 
      @md5 = md5
    end
end