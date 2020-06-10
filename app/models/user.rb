class User < ActiveRecord::Base
    has_secure_password   #Bcrypt
    has_many :posts
    has_many :comments

    validates_presence_of :posts
    validates_presence_of :comments

    def slug
      username.downcase.gsub(" ","-")
    end

    def self.find_by_slug(slug)
      User.all.find{|user| user.slug == slug}
    end

  end
