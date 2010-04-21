class Venue < ActiveRecord::Base 
  validates_presence_of :jambase_id, :name, :city
  validates_uniqueness_of :jambase_id
  
  has_many :events
end
