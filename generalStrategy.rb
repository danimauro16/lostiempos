require 'HTTParty'
require 'Nokogiri'
require 'Digest'

class GeneralStrategy

  attr_accessor :domine, :page, :parsePage, :strategies

  def initialize(strategies)
    @strategies = strategies
  end

  def loadPage(page)
    @domine = page
    @page = HTTParty.get(@domine)
    @parsePage ||= Nokogiri::HTML(@page.body, Encoding::UTF_8.to_s)
    return @parsePage
  end

  def getArticle
  end

  def getSubPage(url)
    return Nokogiri::HTML(HTTParty.get(url).body, nil, Encoding::UTF_8.to_s)
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

  def getMD5(url, body)
    return Digest::MD5.hexdigest(url+body)
  end

end