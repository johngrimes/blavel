class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :first_name,                :string
      t.column :surname,                   :string
      t.column :date_of_birth,             :date
      t.column :gender,                    :string
      t.column :home_town,                 :string
      t.column :about_me,                  :text
      t.column :fave_travel_experience,    :text
      t.column :languages,                 :string
      t.column :time_zone,                 :string
      t.column :admin,                     :boolean
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime
    end
    add_index :users, :login, :unique => true
    add_index :users, :activation_code, :unique => true
    
    create_table :follows, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :follower_id
      t.integer :followee_id
      t.timestamp :created_at
    end
    add_index :follows, :follower_id
    add_index :follows, :followee_id
  end

  def self.down
    if table_exists?(:users)
      drop_table :users
    end
    if table_exists?(:follows)
      drop_table :follows
    end
  end
end
