require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  def test_votes_have_mandatory_fields
    v = VoteUp.new(:user_id => 1, :event_id => 2)
    assert v.save
    
    v = VoteUp.new(:user_id => 1)
    assert !v.save
    
    v = VoteUp.new(:user_id => 1)
    assert !v.save
  end    
  
  def test_votes_associated_with_events
    event_1 = Event.new(:jambase_id => 130442, :ticket_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
    assert event_1.save
    
    v = VoteUp.new(:user_id => 1, :event_id => event_1.id)
    assert v.save             
    
    event_1.reload
    
    assert_equal event_1, v.event
  end 
  
  def test_votes_associated_with_events
    # event_1 = Event.new(:jambase_id => 130442, :ticket_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
    # assert event_1.save 
    # 
    # user = User.new(:email => "joel@goodguide.com", :first_name => "Joel", :last_name => "Lewenstein", :password => "randyjacksonmusic")
    # assert user.save
    # 
    # v = VoteUp.new(:user_id => user.id, :event_id => event_1.id)
    # assert v.save             
    # 
    # event_1.reload
    # 
    # assert_equal user, v.user   
  end
  
  def test_user_can_vote_once_per_event   
    event_1 = Event.new(:jambase_id => 130442, :ticket_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
    assert event_1.save 
    
    v = VoteUp.new(:user_id => 12, :event_id => event_1.id)
    assert v.save
    
    # This user can't vote the same again (in the same way)
    v2 = VoteUp.new(:user_id => 12, :event_id => event_1.id)
    assert !v2.save  
    
    # But they can vote differently
    v4 = VoteDown.new(:user_id => 12, :event_id => event_1.id)
    assert v4.save
    
    # And a new user one can vote up
    v3 = VoteUp.new(:user_id => 13, :event_id => event_1.id) 
    assert v3.save   
    
    # And that first user can vote on another event
    v4 = VoteUp.new(:user_id => 12, :event_id => 67767)
    assert v4.save
  end   

end
