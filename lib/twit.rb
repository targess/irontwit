require 'open-uri'

class Twit
  attr_accessor :favs
  attr_reader :msg, :start_date, :end_date, :user, :image
  def initialize(msg, user = nil, start_date = nil, end_date = nil)
    @start_date = start_date || Date.today - 1
    @end_date = end_date || Date.today + 10
    @msg = msg
    @favs = 0
    @user = user

    image_url = get_image_url
    image_name = get_image_name

    if image_url != ""
      begin
        download = open(image_url)
        IO.copy_stream(download, "public/#{get_image_name}")
        rescue OpenURI::HTTPError
          @image = nil
          @msg.gsub!(image_url,'INVALID URL')
        else
          @image = image_name
        end   
    else 
       @image = nil
    end
  end

  def popular?
    @favs
  end

  def get_image_url
    @msg.match(/http:\/\/((\w|\W)+).(\w{2,3})\/(((\w|\W)+)\/)*((\w|\W)+.(jpg|png))/).to_s
  end

  def get_image_name
    image_url = get_image_url
    return if image_url == ""
    image_url.match(/((\w|-)+.(jpg|png))/).to_s
  end
  
  def status
    result = (@start_date..@end_date).to_a.include? Date.today
    result ? "visible" : "invisible"
  end
  
  def hashtags
    @msg.match(/#(\w+)/).to_a
  end
  
  def valid?
    message = @msg.gsub(get_image_url,"").to_s
    message.length < 140
  end
end