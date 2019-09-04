class User < ApplicationRecord  
  paginates_per 8
  validates :name, presence: true
  validates :twitterUrl, presence: true
  validates_uniqueness_of :twitterUrl
end
