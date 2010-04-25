class Vote < ActiveRecord::Base 
  validates_presence_of :user_id, :event_id, :kind
  validates_uniqueness_of :user_id, :scope => [:event_id, :kind]
  
  belongs_to :event
  belongs_to :user
  
  # If you're voting up or down, remove the opposite
  def after_create
    kind_to_find = nil
    
    if self.kind == "Up"
      kind_to_find = "Down"
    elsif self.kind == "Down"
      kind_to_find = "Up"
    end
    
    if kind_to_find
      v = Vote.find_by_user_id_and_event_id_and_kind(self.user_id, self.event_id, kind_to_find)
      v.delete if v
    end 
  end
end
