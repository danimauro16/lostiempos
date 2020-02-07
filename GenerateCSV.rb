require 'csv'
require './generalStrategy.rb'

class GenerateCSV < GeneralStrategy

  attr_accessor :articlesData

  def initialize(articleData)
    @articlesData = articleData
  end

  def generateDocument()
    index = 0;
    CSV.open("./danielDatos.csv", "a") do |doc|
      @articlesData.each do |arti|
          index = index + 1
          doc << [index, arti.url, arti.title, arti.body, arti.dateScraper, arti.md5]
      end
    end
  end

end