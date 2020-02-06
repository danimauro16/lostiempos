require 'csv'
require './lostiemposStrategy.rb'
require './opinionStrategy.rb'

class Scraper

attr_accessor :articles, :pages, :articlesData

  def initialize
    @articlesData = Array[]
    @pages = Array [
      {
        "strategy" => "LosTiemposStrategy",
        "page" => "https://www.lostiempos.com"
      },
      {
        "strategy" => "OpinionStrategy",
        "page" => "https://www.opinion.com.bo"
      }
    ]
  end

  def getData
    @pages.each do |page|
      strategy = Object.const_get(page["strategy"]).new(page)
      @articlesData = @articlesData | strategy.getArticle()
    end
    CSVgenerate()
  end

  def CSVgenerate
    index = 0;
    CSV.open("./danielDatos.csv", "a") do |doc|
      @articlesData.each do |arti|
        index = index + 1
        doc << [index, arti.url, arti.title, arti.body, arti.dateScraper, arti.md5]
      end
    end
  end 
  
  scraper = Scraper.new()
  scraper.getData()
end