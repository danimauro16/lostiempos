require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'
require './news.rb'
require 'Digest'

class Scraper

attr_accessor :parsePage, :articles, :allArticles, :domine, :page

  def initialize(domine)
    @domine = domine
    @page = HTTParty.get(@domine)
    @parsePage ||= Nokogiri::HTML(@page, Encoding::UTF_8.to_s)
    @articleSelector = parsePage.css('.views-row, table .col-1, table .col-2, table .col-3, table .col-4')
    @articles = Array[];
  end

  def getArticle()
   @articleSelector.map do | article |
      article.css('.views-field-title a').map do | news |
        if (news['href'])
          newsUrl = @domine+news['href']
          news = Nokogiri::HTML(HTTParty.get(newsUrl), Encoding::UTF_8.to_s)
          getNewsInfo(news, newsUrl)
        end
      end
    end
    CSVgenerate()
  end

  def getNewsInfo(news, url)
    titleEndUrlSelector = news.css('.node-header h1')
    bodySelector = news.css('.body p, .content p')
    title = getTitles(titleEndUrlSelector)
    body = getBody(bodySelector)
    date = getNewDate()
    md5 = getMD5(url, body)
    @articles.push(News.new(url, title , body, date, md5))
  end

  def getTitles(titles)
    return titles.each do | data |
      return (data.text) ? data.text.strip() : ""
    end
  end

  def getBody(body)
    return body.text.tr("\n","").strip()[0...100]+"..."
  end

  def getNewDate
    time = Time.now
    return time.strftime("%d-%m-%Y")
  end

  def getMD5 (url, body)
    return Digest::MD5.hexdigest(url+body)
  end

  def CSVgenerate
    index = 0;
    CSV.open("./lostiempos.csv", "a") do |doc|
      @articles.each do |arti|
        doc << [arti.uri, arti.title, arti.body, arti.dateScraper, arti.md5]
      end
    end
  end 
  
  scraper = Scraper.new('https://www.lostiempos.com')
  scraper.getArticle()
end