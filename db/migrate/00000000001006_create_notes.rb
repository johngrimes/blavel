class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :post_id,      :integer
      t.column :picture_id,   :integer
      t.column :user_id,      :integer
      t.column :content,      :text
      t.timestamp :created_at
    end
    add_index :notes, :post_id
    add_index :notes, :picture_id
  end

  def self.down
    if table_exists?(:notes)
      drop_table :notes
    end
  end
end
