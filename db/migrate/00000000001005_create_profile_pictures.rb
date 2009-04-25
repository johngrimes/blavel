class CreateProfilePictures < ActiveRecord::Migration
  def self.up
    create_table :profile_pictures, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :user_id,      :integer
      t.column :filename,     :string
      t.column :content_type, :string
      t.column :size,         :integer
      t.column :width,        :integer
      t.column :height,       :integer
      t.column :parent_id,    :integer
      t.column :thumbnail,    :string
      t.timestamp :created_at
      t.timestamp :updated_at
    end
    add_index :profile_pictures, :user_id
    add_index :profile_pictures, [ :parent_id, :thumbnail ], :unique => true
  end

  def self.down
    if table_exists?(:profile_pictures)
      ProfilePicture.destroy_all
      drop_table :profile_pictures
    end
  end
end
