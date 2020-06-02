class Post < ActiveRecord::Base
    has_many :post_destinations
    has_many :destinations, through: :post_destinations
    has_many :comments
    belongs_to :user
  end
