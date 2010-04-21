require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  def test_has_required_fields
    a = Artist.new(:jambase_id => 130442, :name => "Foo Fighters")
    assert a.save
    
    a = Artist.new(:name => "Foo Fighters")
    assert !a.save
    
    a = Artist.new(:jambase_id => 130442)
    assert !a.save
  end     
  
  def test_uniqueness_of_jambase_id
    a = Artist.new(:jambase_id => 13, :name => "Foo Fighters")
    assert a.save
    
    b = Artist.new(:jambase_id => 13, :name => "Hold Steady")
    assert !b.save
    b.jambase_id = 14
    assert b.save
  end         
  
  def test_has_association_with_events
    chili_peppers = Artist.new(:jambase_id => 12345, :name => "Chili peppers")
    assert chili_peppers.save
    assert_equal [], chili_peppers.events
    
    beatles = Artist.new(:jambase_id => 67890, :name => "Beatles")
    assert beatles.save
    assert_equal [], beatles.events
    
    fri_night = Event.new(:jambase_id => 130442, :ticket_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
    assert fri_night.save
    assert_equal [], fri_night.artists
    
    sat_night = Event.new(:jambase_id => 130443, :ticket_url => "http://www.fake.com", :date => Time.now, :venue_id => 12)
    assert sat_night.save
    assert_equal [], sat_night.artists
     
    # CP playing on Fri Night
    fri_night.artists << chili_peppers
    fri_night.reload
    chili_peppers.reload
    assert_equal [fri_night], chili_peppers.events
    assert_equal [chili_peppers], fri_night.artists 
    
    # CP also plahying on Sat
    sat_night.artists << chili_peppers
    sat_night.reload
    chili_peppers.reload
    assert_equal [fri_night, sat_night], chili_peppers.events
    assert_equal [chili_peppers], sat_night.artists   
    
    # Beatles playing on Fri Night
    fri_night.artists << beatles
    fri_night.reload
    beatles.reload
    assert_equal [fri_night], beatles.events
    assert_equal [chili_peppers, beatles], fri_night.artists
  end
end
