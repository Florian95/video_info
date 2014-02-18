class Dailymotion

  attr_accessor :video_id, :url, :provider, :title, :description, :keywords,
                :duration, :date, :width, :height, :embed_url,
                :thumbnail_small, :thumbnail_large, :player,
                :view_count,
                :openURI_options

  def initialize(url, options = {})
    @openURI_options = options
    @video_id = url.gsub(/.*\.com\/video\/([0-9A-Za-z-]+).*$/i, '\1')
    get_info unless @video_id == url
  end

private

  def fetch_content
    open("http://www.dailymotion.com/rss/video/#{@video_id}", @openURI_options)
  end

  def content
    @content ||= fetch_content
  end

  def get_info
    doc = Nokogiri::XML(content)
    @provider         = "Dailymotion"
    @url              = doc.search("guid").inner_text
    @title            = doc.search("//media:title").inner_text
    @description      = doc.search("//itunes:summary").inner_text
    @keywords         = doc.search("//itunes:keywords").inner_text
    @duration         = doc.search("//media:content").first[:duration].to_i
    @width            = doc.search("//media:player").first[:width].to_i
    @height           = doc.search("//media:player").first[:height].to_i
    @date             = Time.parse(doc.search("//item/pubDate").inner_text)
    @thumbnail_small  = doc.search("//media:thumbnail").first[:url]
    @thumbnail_large  = doc.search("//media:thumbnail").last[:url]
    content           = doc.search("//media:content").first
    @view_count       = doc.search("//dm:views").inner_text.to_i
    @player           = "http://www.dailymotion.com/swf/video/#{@video_id}"
  end

end
