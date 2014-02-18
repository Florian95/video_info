class Youtube
  attr_accessor :video_id, :embed_url, :url, :provider, :title, :description, :keywords,
                :duration, :date, :width, :height,
                :thumbnail_small, :thumbnail_large,
                :view_count,
                :openURI_options

  def initialize(url, options = {})
    @openURI_options = options
    video_id_for(url)
    get_info unless @video_id == url
  end

  def regex
    /youtu(.be)?(be.com)?.*(?:\/|v=)([\w-]+)/
  end

  def video_id_for(url)
    url.gsub(regex) do
      @video_id = $3
    end
  end

private

  def fetch_content
    open("http://gdata.youtube.com/feeds/api/videos/#{@video_id}", @openURI_options)
  end

  def content
    @content ||= fetch_content
  end

  def get_info
    doc = Nokogiri::XML(content)
    @provider         = "YouTube"
    @url              = "http://www.youtube.com/watch?v=#{@video_id}"
    @embed_url        = "http://www.youtube.com/embed/#{@video_id}"
    @title            = doc.at_xpath('//media:title').text
    @description      = doc.at_xpath('//media:description').text
    @keywords         = doc.at_xpath('//media:keywords').text
    @duration         = doc.at_xpath('//yt:duration').attr('seconds').to_i
    published_at      = doc.search('published').first.text
    @date             = Time.parse(published_at, Time.now.utc)
    thumbnails = doc.xpath('//media:thumbnail')
    @thumbnail_small  = thumbnails.last['url']
    @thumbnail_large  = thumbnails.first['url']
    # when your video still has no view, yt:statistics is not returned by Youtube
    # see: https://github.com/thibaudgg/video_info/issues#issue/2
    @view_count = doc.at_xpath('//yt:statistics').nil? ? 0 : doc.at_xpath('//yt:statistics')['viewCount'].to_i
  end

end
