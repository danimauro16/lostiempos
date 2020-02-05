require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'
require './news.rb'
require 'Digest'

class Scraper

attr_accessor :parsePage, :articles, :allArticles, :domine, :page

  def initialize
    @domine = 'https://www.lostiempos.com'
    @page = HTTParty.get("https://www.lostiempos.com/")
    @parsePage ||= Nokogiri::HTML(page, Encoding::UTF_8.to_s)
    @articlesSelector = parsePage.css('.views-row, table .col-1, table .col-2, table .col-3, table .col-4')
    @articles = Array[];
  end

  def getArticle()
    @articlesSelector.map do | article |
      article.css('.views-field-title a').map do | news |
        bodyNews = "";
        article.css('.sin-sumario').map do | body |
          if (body.text != "")
            bodyNews = body.text.strip().tr("\n","")
          end
        end
        md5 = getMD5(news['href'], news.text)
        url = domine + news['href']
        newsTitle = news.text.strip().tr("\n"," ")
        @articles.push(News.new(url, newsTitle , bodyNews, getNewDate(), md5))
      end
    end
    CSVgenerate()
  end

  def CSVgenerate
    index = 0;
    CSV.open("../opinion/DatosDaniel.csv", "a") do |doc|
      @articles.each do |arti|
        doc << [arti.uri, arti.title, arti.body, arti.dateScraper, arti.md5]
      end
    end
  end 

  def getNewDate
    time = Time.now
    return time.strftime("%d-%m-%Y")
  end

  def getMD5 (url, body)
    return Digest::MD5.hexdigest(url+body)
  end

  scraper = Scraper.new
  scraper.getArticle()

end