class ProfilePicture < ActiveRecord::Base
  belongs_to :user
  has_attachment  :storage => :file_system, 
    :max_size => 20.megabytes,
    :content_type => :image,
    :thumbnails => { :display => '200x200>', :tiny => '100x100>', :xtiny => '50x50>' },
    :processor => :MiniMagick
end
