class User < ApplicationRecord    
  paginates_per 8
  validates :name, presence: true
  validates :twitterUrl, presence: true
  validates :twitterName, presence: { message: 'Usuario não encontrado'}
  validates_uniqueness_of :twitterName
end
