class Event < ActiveRecord::Base
  validates_presence_of :jambase_id, :venue_id, :date
  validates_uniqueness_of :jambase_id
  
  belongs_to :venue 
  has_and_belongs_to_many :artists, :uniq => true
  
  has_many :votes
  has_many :votes_up, :class_name => "Vote", :conditions => "kind = 'Up'"
  has_many :votes_down, :class_name => "Vote", :conditions => "kind = 'Down'"
  has_many :votes_attending, :class_name => "Vote", :conditions => "kind = 'Attending'"
  
  
  require 'statistics2'
  
  def votes_up_count
    self.votes_up.length
  end
  
  def votes_down_count
    self.votes_down.length
  end
  
  def attendance_count
    self.votes_attending.length
  end
  
  def total_votes_count
    votes_up_count + votes_down_count
  end
  
  def up_down_vote_for_user(user)
    (self.votes_up + self.votes_down).find{|vote| vote.user = user}
  end
  
  def attending_vote_for_user(user)
    [self.votes_attending].flatten.find{|vote| vote.user = user}
  end
  
  def comments
    self.votes.collect{|vote| vote.comment }.compact.reject{|comment| comment.blank? }
  end   
  
            
  
  # The GoodLive Rating: Currently based on the Lower bound of Wilson score confidence interval for a Bernoulli parameter 
  def rating
    if total_votes_count == 0
      -1
    else
      wilson_score_rating(votes_up_count, total_votes_count, 0.15)
    end
  end
  
  # Pos = number of positive ratings
  # n = total ratings
  # power = confidence
  # http://www.evanmiller.org/how-not-to-sort-by-average-rating.html
  
  def wilson_score_rating(pos, n, power) 
    if n == 0
        return 0
    end
    z = Statistics2.pnormaldist(1-power/2)
    phat = 1.0*pos/n
    (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)    
  end
end
