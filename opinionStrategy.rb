require './generalStrategy.rb'
require './news.rb'

class OpinionStrategy < GeneralStrategy

  attr_accessor :domine, :strategy, :parsePage, :page, :articles, :article

  def initialize(strategy)
    @domine = strategy["page"]
    @articles = Array[]
  end

  def getArticle
    page = loadPrincipalPage(@domine)
    page.css('.article-data a').map do | news |
      newsUrl = @domine+news['href']
      news = getSubPage(newsUrl)
      titleEndUrlSelector = news.css('.content-header h2')
      bodySelector = news.css('.body p')
      title = getTitles(titleEndUrlSelector)
      body = getBody(bodySelector)
      date = getNewDate()
      md5 = getMD5(newsUrl, body)
      @articles.push(News.new(newsUrl, title , body, date, md5))
    end
    return @articles
  end
end