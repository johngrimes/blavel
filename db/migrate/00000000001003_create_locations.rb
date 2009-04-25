class CreateLocations < ActiveRecord::Migration
  def self.up
    down    
    create_table :locations, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :name, :limit => 200
      t.string :ascii_name, :limit => 200
      t.string :alternate_names, :limit => 5000
      t.string :latitude, :limit => 20
      t.string :longitude, :limit => 20
      t.string :location_type_code, :limit => 1
      t.string :feature_class, :limit => 10
      t.string :country_code, :limit => 2
      t.string :alternate_iso_alpha_2, :limit => 60
      t.string :admin_1_code, :limit => 20
      t.string :admin_2_code, :limit => 80
      t.string :admin_3_code, :limit => 20
      t.string :admin_4_code, :limit => 20
      t.integer :population
      t.string :elevation, :limit => 20
      t.string :gtopo30, :limit => 20
      t.string :time_zone, :limit => 50
      t.date :modification_date
    end
    
    create_table :location_types, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :code, :limit => 1
      t.string :description, :limit => 50
      
    end
    add_index :location_types, :code, :unique => true
    
    create_table :countries, :id => false, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :code, :limit => 2
      t.string :iso_alpha_3, :limit => 3
      t.integer :iso_numeric
      t.string :fips_code, :limit => 2
      t.string :name, :limit => 255
      t.string :capital, :limit => 255
      t.string :area_in_sq_km, :limit => 20
      t.string :population, :limit => 20
      t.string :continent_id, :limit => 2
      t.string :tld, :limit => 3
      t.string :currency_code, :limit => 3
      t.string :currency_name, :limit => 30
      t.string :phone, :limit => 30
      t.string :postal_code_format, :limit => 500
      t.string :postal_code_regex, :limit => 500
      t.string :languages, :limit => 255
      t.integer :location_id
      t.string :neighbours, :limit => 255
      t.string :equivalent_fips, :limit => 20
    end
    add_index :countries, :code, :unique => true
    
    create_table :continents, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :code, :limit => 2
      t.string :name, :limit => 50
    end
    add_index :continents, :code, :unique => true
    
    create_table :locations_posts, :id => false, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :post_id
      t.integer :location_id
    end
    add_index :locations_posts, :post_id
    add_index :locations_posts, :location_id
  end

  def self.down
    if table_exists?(:locations)
      drop_table :locations
    end
    if table_exists?(:location_types)
      drop_table :location_types
    end
    if table_exists?(:countries)
      drop_table :countries
    end
    if table_exists?(:continents)
      drop_table :continents
    end
    if table_exists?(:locations_posts)
      drop_table :locations_posts
    end
  end
end
