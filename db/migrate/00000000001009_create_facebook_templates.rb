class CreateFacebookTemplates < ActiveRecord::Migration
  def self.up
    create_table :facebook_templates, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|      
      t.string :template_name, :null => false
      t.string :content_hash, :null => false
      t.string :bundle_id, :null => true
    end
    add_index :facebook_templates, :template_name, :unique => true
  end

  def self.down
    if table_exists?(:facebook_templates)
      drop_table :facebook_templates
    end
  end
end
