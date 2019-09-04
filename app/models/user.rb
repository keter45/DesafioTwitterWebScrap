class User < ApplicationRecord  
  URL_REGEXP = /http(?:s)?:\/\/(?:www\.)?twitter\.com\/([a-zA-Z0-9_]+)/
  paginates_per 8
  validates :name, presence: true
  validates :twitterUrl, presence: true
  validates :twitterName, presence: { message: 'Usuario não encontrado'}
  validates :twitterUrl, format: { with: URL_REGEXP, message: 'Url invalido' }
  validates_uniqueness_of :twitterUrl
end
