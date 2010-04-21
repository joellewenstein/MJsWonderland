class Artist < ActiveRecord::Base
  validates_presence_of :jambase_id, :name 
  validates_uniqueness_of :jambase_id
  
  has_and_belongs_to_many :events
end
