class CreatePost < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
  		t.string :title
  		t.string :content
      t.date :travel_date
      t.date :return_date
      t.timestamps
  	end
  end
end
