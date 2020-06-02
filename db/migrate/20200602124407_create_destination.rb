class CreateDestination < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
  		t.string :country
  	end
  end
end
