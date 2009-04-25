class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.text :content
      t.boolean :read, :default => false
      t.timestamp :created_at
    end
  end

  def self.down
    if table_exists?(:messages)
      drop_table :messages
    end
  end
end
