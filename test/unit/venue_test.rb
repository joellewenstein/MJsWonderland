require 'test_helper'

class VenueTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  def test_has_required_fields
    v = Venue.new(:jambase_id => 7, :name => "Bottom of the Hill", :city => "San Francisco", :state => "CA", :zip => "14850")
    assert v.save
    
    v = Venue.new(:name => "Bottom of the Hill", :city => "San Francisco", :state => "CA", :zip => "14850")
    assert !v.save
    
    v = Venue.new(:jambase_id => 7, :city => "San Francisco", :state => "CA", :zip => "14850")
    assert !v.save
    
    v = Venue.new(:jambase_id => 7, :name => "Bottom of the Hill", :state => "CA", :zip => "14850")
    assert !v.save  
    
    v = Venue.new(:jambase_id => 7, :name => "Bottom of the Hill", :city => "San Francisco")
    assert v.save  
  end
  
  
  def test_uniqueness_of_jambase_id
    a = Venue.new(:jambase_id => 7, :name => "Bottom of the Hill", :city => "San Francisco", :state => "CA", :zip => "14850")
    assert a.save
    
    b = Venue.new(:jambase_id => 7, :name => "Bottom of the Hill", :city => "San Francisco", :state => "CA", :zip => "14850")
    assert !b.save
    b.jambase_id = 14
    assert b.save
  end
end
