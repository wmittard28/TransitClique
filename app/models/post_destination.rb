class PostDestination < ActiveRecord::Base
    belongs_to :post
    belongs_to :destination
   end
