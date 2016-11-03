require 'spec_helper'
require 'date'

RSpec.describe Twit do

  describe "popular" do
    it "has more than one fav" do
      twit = Twit.new("message")
      twit.favs += 1
      expect(twit.popular?).to be >= 1
    end
    it "has no favs" do
      twit = Twit.new("message")
      twit.favs = 0
      expect(twit.popular?).to eq(0)
    end
  end

  describe "has a image" do
 
    it "returns no images in case invalid url" do
    twit = Twit.new("message http://example.com/image.jpg")
    expect(twit.image).to be(nil)
    end

    it "returns the first image from url" do
    twit = Twit.new("message https://www.wikipedia.org/portal/wikipedia.org/assets/img/Wikipedia-logo-v2.png")
    expect(twit.image).to eq("Wikipedia-logo-v2.png")
    end    

    it "has no image" do
    twit = Twit.new("message image.jpg")
    expect(twit.image).to eq(nil)
    end
  end
  
  describe ".status" do
    it "is visible when date is between start and end" do
      start_date = Date.today - 1
      end_date = Date.today + 1
      twit = Twit.new("message", "pepe", start_date, end_date)
      expect(twit.status).to eq("visible")
    end
    
    it "is invisible when date is not between start and end" do
      start_date = Date.today + 1
      end_date = Date.today + 10
      twit = Twit.new("message", "pepe", start_date, end_date)
      expect(twit.status).to eq("invisible")
    end
  end
  
  describe "tweet message length" do
    it "is invalid over 140 characters" do
      str = "*" * 141
      twit = Twit.new(str)
      
      expect(twit.valid?).to eq(false)
      #expect { Twit.new(str) }.to raise_error
    end

    it "Is valid under 140 and excludes images from count" do
      str = "*" * 139
      str.concat("https://www.wikipedia.org/portal/wikipedia.org/assets/img/Wikipedia-logo-v2.png")
      twit = Twit.new(str)
      expect(twit.valid?).to eq(true)
    end
    
    it "is valid under 140" do
      str = "*" * 139
      twit = Twit.new(str)
      
      expect(twit.valid?).to eq(true)
    end
  end
  
  describe ".hashtags" do
    it "extracts the correct amount of hashtags" do
      msg = "chicos y chicas no es chiques #feminism, #machirulo"
      twit = Twit.new(msg)
      expect(twit.hashtags.size).to eql(2)
    end
  
    it "works for zero hashtags" do
      msg = "chicos y chicas no es chiques"
      twit = Twit.new(msg)
      expect(twit.hashtags.size).to eql(0)
    end
    
    it "returns the correct hashtgas" do
      msg = "chicos y chicas no es chiques #feminism"
      twit = Twit.new(msg)
      expect(twit.hashtags).to include("#feminism")
    end
  end
end


