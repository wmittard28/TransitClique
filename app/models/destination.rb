class Destination < ActiveRecord::Base
    has_many :post_destinations
    has_many :posts, through: :post_destinations
  end
