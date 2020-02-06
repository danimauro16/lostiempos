require './generalStrategy.rb'

class LosTiemposStrategy < GeneralStrategy
  
  attr_accessor :domine, :strategy, :parsePage, :page, :articles

  def initialize(strategy)
    @domine = strategy["page"]
    @articles = Array[]
  end

  def getArticle
    page = loadPage(@domine)
    page.css('.views-field-title a').map do | news |
      newsUrl = @domine+news['href']
      news = getSubPage(newsUrl)
      titleEndUrlSelector = news.css('.node-header h1')
      bodySelector = news.css('.body p, .content p')
      title = getTitles(titleEndUrlSelector)
      body = getBody(bodySelector)
      date = getNewDate()
      md5 = getMD5(newsUrl, body)
      @articles.push(News.new(newsUrl, title , body, date, md5))
    end
    return @articles
  end
end