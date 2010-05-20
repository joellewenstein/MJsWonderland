class Artist < ActiveRecord::Base
  validates_presence_of :jambase_id, :name 
  validates_uniqueness_of :jambase_id
  
  has_and_belongs_to_many :events
  
  def album_image
    "http://fashionducolor.files.wordpress.com/2009/11/lady-gaga-album_cover-the_fame.jpg"
  end
end
