class Vote < ActiveRecord::Base 
  validates_presence_of :user_id, :event_id
  validates_uniqueness_of :user_id, :scope => [:event_id, :type]
  
  belongs_to :event
  #belongs_to :user
end
