class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :post_id,      :integer
      t.column :title,        :string
      t.column :description,  :string,  :limit => 300
      t.column :location_id,  :integer
      t.column :sequence,     :integer
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
    add_index :pictures, :post_id
    add_index :pictures, :location_id
    add_index :pictures, [ :parent_id, :thumbnail ], :unique => true
  end

  def self.down
    if table_exists?(:pictures)
      Picture.destroy_all
      drop_table :pictures
    end
  end
end
