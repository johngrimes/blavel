class CreateFacebookUsers < ActiveRecord::Migration
  def self.up
    create_table :facebook_users, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :user_id,      :integer
      t.column :facebook_id,  :integer
      t.column :session_key,   :string
      t.timestamp :created_at
    end
    add_index :facebook_users, :user_id
    add_index :facebook_users, :facebook_id
  end

  def self.down
    if table_exists?(:facebook_users)
      drop_table :facebook_users
    end
  end
end
