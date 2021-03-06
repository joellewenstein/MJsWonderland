require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  # Required fields are jambase_id, date, venue
  def test_has_required_fields
   # Complete event
   # e = Event.new(:jambase_id => 130442, :ticket_url => "http://www.fake.com", :event_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
   
   e = Event.new(:jambase_id => 130442, :ticket_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
   assert e.save
   
   e = Event.new(:jambase_id => 130442, :event_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)  
   assert e.save
   
   e = Event.new(:ticket_url => "http://www.fake.com", :event_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)  
   assert !e.save
   
   e = Event.new(:jambase_id => 130442, :ticket_url => "http://www.fake.com", :event_url => "http://www.fake.com", :venue_id => 12)
   assert !e.save                                                                
   
   e = Event.new(:jambase_id => 130442, :ticket_url => "http://www.fake.com", :event_url => "http://www.fake.com", :date => Time.now)
   assert !e.save
  end
  
  def test_uniqueness_of_jambase_id
    a = Event.new(:jambase_id => 13, :ticket_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
    assert a.save
    
    b = Event.new(:jambase_id => 13, :ticket_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
    assert !b.save
    b.jambase_id = 14
    assert b.save
    
  end
  
  def test_association_with_venue
    music_hall = Venue.new(:jambase_id => 1, :name => "Cool Kids Music Hall", :city => "San Francisco")
    assert music_hall.save
    
    saturday_night = Event.new(:jambase_id => 130442, :date => Time.now, :ticket_url => "http://www.fake.com", :event_url => "http://www.fake.com", :venue_id => music_hall.id) 
    assert saturday_night.save!
    
    assert_equal music_hall, saturday_night.venue
    assert_equal [saturday_night], music_hall.events  
    
    better_music_hall = Venue.new(:jambase_id => 2, :name => "Better Music Hall", :city => "San Francisco")
    assert better_music_hall.save
    
    saturday_night.venue = better_music_hall
    assert saturday_night.save
    saturday_night.reload
    music_hall.reload  
    
    assert_equal better_music_hall, saturday_night.venue
    assert_equal [], music_hall.events 
    assert_equal [saturday_night], better_music_hall.events 
  end 
  
  def test_association_with_votes
    event_1 = Event.new(:jambase_id => 13, :ticket_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
    assert event_1.save

    v = Vote.new(:user_id => 1, :event_id => event_1.id, :kind => "Up")
    assert v.save             

    event_1.reload

    assert_equal [v], event_1.votes  
  end  
  
  def test_can_count_up_and_down_votes
    event_1 = Event.new(:jambase_id => 13, :ticket_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
    assert event_1.save
    
    # 10 up votes
    10.times do |x|
      v = Vote.new(:user_id => x, :event_id => event_1.id, :kind => "Up") 
      assert v.save
    end
    
    # 3 down votes
    3.times do |y|
      v = Vote.new(:user_id => (100 + y), :event_id => event_1.id, :kind => "Down") 
      assert v.save!
    end 
    
    assert_equal 10, event_1.votes_up_count
    assert_equal 3, event_1.votes_down_count  
  end 
  
  def test_can_count_attendance
    event_1 = Event.new(:jambase_id => 13, :ticket_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
    assert event_1.save
    
    assert_equal 0, event_1.attendance_count
    
    3.times do |y|
      v = Vote.new(:user_id => (100 + y), :event_id => event_1.id, :kind => "Attending") 
      assert v.save!
    end
    
    event_1.reload
    
    assert_equal 3, event_1.attendance_count
  end
  
  
  ### Ratings ####
  
  def test_event_has_rating
    event_1 = Event.new(:jambase_id => 13, :ticket_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
    assert event_1.save
   
    assert !event_1.rating
    
    # 10 up votes
    10.times do |x|
      v = Vote.new(:user_id => x, :event_id => event_1.id, :kind => "Up") 
      assert v.save
    end
    
    # 3 down votes
    3.times do |y|
      v = Vote.new(:user_id => (100 + y), :event_id => event_1.id, :kind => "Down") 
      assert v.save
    end 
    
    event_1.reload
    
    assert event_1.rating
  end 
  
  def test_rating_goes_up_with_more_positive_ratings
    event_1 = Event.new(:jambase_id => 13, :ticket_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
    assert event_1.save
    
    # 2 up votes
    2.times do |x|
      v = Vote.new(:user_id => x, :event_id => event_1.id, :kind => "Up") 
      assert v.save!
    end
    
    # 4 down votes
    4.times do |y|
      v = Vote.new(:user_id => (100 + y), :event_id => event_1.id, :kind => "Down") 
      assert v.save!
    end
    
    first_rating = event_1.rating
    
    # More up votes
    6.times do |x|
      v = Vote.new(:user_id => 200 + x, :event_id => event_1.id, :kind => "Up") 
      assert v.save
    end   
    
    event_1.reload
    
    second_rating = event_1.rating
    
    assert (first_rating < second_rating)
  end
end
