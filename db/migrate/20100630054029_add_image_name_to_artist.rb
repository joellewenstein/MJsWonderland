class AddImageNameToArtist < ActiveRecord::Migration
  def self.up      
    add_column :artists, :image_name, :string
  end

  def self.down                              
   remove_column :aritsts, :image_name
  end
end
