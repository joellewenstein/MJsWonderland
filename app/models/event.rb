class Event < ActiveRecord::Base
  validates_presence_of :jambase_id, :venue_id, :date
  validates_uniqueness_of :jambase_id
  
  belongs_to :venue 
  has_and_belongs_to_many :artists
  
  has_many :votes
  has_many :votes_up, :class_name => "Vote", :conditions => "type = 'VoteUp'"
  has_many :votes_down, :class_name => "Vote", :conditions => "type = 'VoteDown'"
  
  def votes_up_count
    self.votes_up.length
  end
  
  def votes_down_count
    self.votes_down.length
  end
end
