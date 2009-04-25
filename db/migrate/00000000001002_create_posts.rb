class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :user_id
      t.string :title
      t.text :content
      t.timestamp :created_at
      t.timestamp :updated_at
    end
    add_index :posts, :user_id
  end

  def self.down
    if table_exists?(:posts)
      drop_table :posts
    end
  end
end
