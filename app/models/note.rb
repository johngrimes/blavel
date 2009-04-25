class Note < ActiveRecord::Base
  belongs_to :post
  belongs_to :picture
  belongs_to :user
  
  validates_presence_of :content
end
