namespace :good_live do
  task :get_data_from_jambase => :environment do
    puts "Getting information from jambase"
    
    require 'nokogiri'
    require 'open-uri'
    
    doc = Nokogiri::HTML(open('http://api.jambase.com/search?zip=94102&radius=1&apikey=tggvg5fyv3m8z4qaqrj36dtw&startDate=7/01/10&endDate=09/01/10'))
    
    doc.css('event').each do |event|
      #########
      # EVENT #
      #########     
      jambase_event_id = event.at_css("event_id").content
      
      e = Event.find_by_jambase_id(jambase_event_id.to_i)
      
      if !e
        e = Event.new(:jambase_id => jambase_event_id.to_i)
      end
            
      event_date = event.at_css("event_date").content 
      e.date = Date.parse(event_date)  
      
      event_ticket_url = (event.at_css("ticket_url") ? event.at_css("ticket_url").content : nil) 
      e.ticket_url = event_ticket_url
      
      event_url = event.at_css("event_url").content 
      e.event_url = event_url
      
      ##########
      # ARTIST #
      ##########
      event.css('artists').each do |artists|
        artists.css('artist').each do |artist|
          artist_jambase_id = artist.at_css("artist_id").content 
          artist_name = artist.at_css("artist_name").content
          
          potentially_existing_artist = Artist.find_by_jambase_id(artist_jambase_id.to_i)
          
          if !potentially_existing_artist
            potentially_existing_artist = Artist.new(:jambase_id => artist_jambase_id.to_i)
          end
          
          potentially_existing_artist.name = artist_name
          potentially_existing_artist.save!
          
          e.artists << potentially_existing_artist
        end 
        
        puts "Created event #{e.to_yaml}" 
      end
      
      ##########
      # VENUE  #
      ##########
      event.css('venue').each do |venue|
        venue_jambase_id = venue.at_css("venue_id").content 
        venue_name = venue.at_css("venue_name").content
        venue_city = venue.at_css("venue_city").content
        venue_state = venue.at_css("venue_state").content
        venue_zip = venue.at_css("venue_zip").content
        
        potentially_existing_venue = Venue.find_by_jambase_id(venue_jambase_id.to_i)
        
        if !potentially_existing_venue
          potentially_existing_venue = Venue.new(:jambase_id => venue_jambase_id.to_i)
        end
        
        potentially_existing_venue.name = venue_name
        potentially_existing_venue.city = venue_city
        potentially_existing_venue.state = venue_state
        potentially_existing_venue.zip = venue_zip
        
        potentially_existing_venue.save!
        
        e.venue = potentially_existing_venue    
      end
      
      e.save!
    end
  end 
  
   task :get_album_art => :environment do
     puts "Populating album art"

     require 'nokogiri'
     require 'open-uri'
     
     Artist.find(:all).each do |artist|
       if artist.image_name.blank? 
         doc = `curl 'http://search.yahooapis.com/ImageSearchService/V1/imageSearch?appid=YahooDemo&query=#{artist.name.gsub(" ", "%20")}%20album%20cover&output=json' ` 
         

         images = ActiveSupport::JSON.decode(doc)  
         album_art_url = images["ResultSet"]["Result"].first["Url"].to_s  
         
         artist.image_name = album_art_url
         artist.save
         
         puts "Added image for artist #{artist.name}"
         
         sleep(5)
       end 
     end
   end   
end