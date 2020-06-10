class User < ActiveRecord::Base
    has_secure_password   #Bcrypt
    has_many :posts
    has_many :comments

    validates :email, :password, :username, presence: true
    validates :email, :username, uniqueness: true

    def slug
      username.downcase.gsub(" ","-")
    end

    def self.find_by_slug(slug)
      User.all.find{|user| user.slug == slug}
    end

  end
