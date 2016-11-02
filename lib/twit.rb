class Twit
  attr_accessor :favs, :user
  attr_reader :msg, :start_date, :end_date, :user
  def initialize(msg, user = nil, start_date = nil, end_date = nil)
    @start_date = start_date || Date.today - 1
    @end_date = end_date || Date.today + 1
    @msg = msg
    @favs = 0
    @user = user
  end

  def popular?
    @favs
  end

  def get_image_url
    @msg.match(/http:\/\/(\w+).(\w{2,3})\/((\w+)\/)*(\w+.(jpg|png))/).to_s
  end

  def get_image
    image_url = get_image_url
    return if image_url == ""
    image_url.match(/(\w+.(jpg|png))/).to_s
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