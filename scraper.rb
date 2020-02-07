require 'csv'
require './lostiemposStrategy.rb'
require './opinionStrategy.rb'
require './GenerateCSV.rb'
require './GenerateTXT.rb'

class Scraper

attr_accessor :articles, :pages, :articlesData

  def initialize
    @articlesData = Array[]
    @resources = Array [
      {
        "strategy" => "LosTiemposStrategy",
        "page" => "https://www.lostiempos.com",
        "typeDocument" => "GenerateCSV"
      },
      {
        "strategy" => "OpinionStrategy",
        "page" => "https://www.opinion.com.bo",
        "typeDocument" => "GenerateTXT"
      }
    ]
  end

  def getData
    @resources.each do |data|
      strategy = Object.const_get(data["strategy"]).new(data)
      @articlesData = strategy.getArticle()
      newDocument = Object.const_get(data["typeDocument"]).new(@articlesData)
      newDocument.generateDocument()
    end
  end 
  
  scraper = Scraper.new()
  scraper.getData()
end