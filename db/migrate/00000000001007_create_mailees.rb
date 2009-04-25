class CreateMailees < ActiveRecord::Migration
  def self.up
    create_table :mailees, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :user_id,      :integer
      t.column :email,        :string
      t.timestamp :created_at
    end
    add_index :mailees, :user_id
  end

  def self.down
    if table_exists?(:mailees)
      drop_table :mailees
    end
  end
end
