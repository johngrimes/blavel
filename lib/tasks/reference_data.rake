namespace :blavel do
  desc 'Download location file from GeoNames'
  task :download_locations do
    locations_path = 'http://download.geonames.org/export/dump/allCountries.zip'
    download_dir = '/var/www/sites/blavel.com/shared/db'
    
    system "rm -f #{download_dir}/locations.txt"    
    system "wget #{locations_path} -O #{download_dir}/locations.zip"
    system "unzip #{download_dir}/locations.zip allCountries.txt -d #{download_dir}"
    system "mv #{download_dir}/allCountries.txt #{download_dir}/locations.txt"
    system "rm -f #{download_dir}/locations.zip"
  end

  desc 'Download country file from GeoNames'
  task :download_countries do
    countries_path = 'http://download.geonames.org/export/dump/countryInfo.txt'
    download_dir = '/var/www/sites/blavel.com/shared/db'
    
    system "rm -f #{download_dir}/countries.txt"
    system "wget #{countries_path} -O #{download_dir}/countries-with-header.txt"
    system "grep -v '^#' #{download_dir}/countries-with-header.txt > #{download_dir}/countries.txt"
    system "rm -f #{download_dir}/countries-with-header.txt"
  end
  
  desc 'Populate locations from downloaded GeoNames file'
  task :populate_locations => :environment do
    download_dir = '/var/www/sites/blavel.com/shared/db'
  
    statement = %{LOAD DATA INFILE '#{download_dir}/locations.txt' 
                  INTO TABLE locations
                  FIELDS TERMINATED BY '\\t'
                  LINES TERMINATED BY '\\n'}
    
    puts 'Clearing locations table...'
    Location.delete_all
    puts "Executing statement: #{statement}"
    Location.connection.execute statement
  end

  desc 'Populate countries from downloaded GeoNames file'
  task :populate_countries => :environment do
    download_dir = '/var/www/sites/blavel.com/shared/db'
    
    statement = %{LOAD DATA INFILE '#{download_dir}/countries.txt' 
                  INTO TABLE countries
                  FIELDS TERMINATED BY '\\t'
                  LINES TERMINATED BY '\\n'
                  IGNORE 1 LINES 
                  (code, iso_alpha_3, iso_numeric, fips_code, name, capital, 
                  area_in_sq_km, population, continent_id, tld, currency_code, 
                  currency_name, phone, postal_code_format, postal_code_regex, 
                  languages, location_id, neighbours, equivalent_fips)}
    
    puts 'Clearing countries table...'
    Country.delete_all
    puts "Executing statement: #{statement}"
    Country.connection.execute statement
  end

  desc 'Populate continents reference data'
  task :populate_continents => :environment do
    puts 'Refreshing continents...'
    Continent.delete_all
    
    africa = Continent.create(:code => 'AF', :name => 'Africa')
    Country.update_all("continent_id = #{africa.id}", 'continent_id = "AF"')
    
    antarctica = Continent.create(:code => 'AN', :name => 'Antarctica')
    Country.update_all("continent_id = #{antarctica.id}", 'continent_id = "AN"')
    
    asia = Continent.create(:code => 'AS', :name => 'Asia')
    Country.update_all("continent_id = #{asia.id}", 'continent_id = "AS"')
    
    europe = Continent.create(:code => 'EU', :name => 'Europe')
    Country.update_all("continent_id = #{europe.id}", 'continent_id = "EU"')
    
    north_america = Continent.create(:code => 'NA', :name => 'North America')
    Country.update_all("continent_id = #{north_america.id}", 'continent_id = "NA"')
    
    oceania = Continent.create(:code => 'OC', :name => 'Oceania')
    Country.update_all("continent_id = #{oceania.id}", 'continent_id = "OC"')
    
    south_america = Continent.create(:code => 'SA', :name => 'South America')
    Country.update_all("continent_id = #{south_america.id}", 'continent_id = "SA"')
  end

  desc 'Populate location types reference data'
  task :populate_location_types => :environment do
    puts 'Refreshing location types...'
    LocationType.delete_all
    LocationType.create(:code => 'P', :description => 'city, town or village')
    LocationType.create(:code => 'T', :description => 'mountain, hill or rock')
    LocationType.create(:code => 'H', :description => 'stream or lake')
    LocationType.create(:code => 'A', :description => 'country, state or region')
    LocationType.create(:code => 'L', :description => 'park or area')
    LocationType.create(:code => 'R', :description => 'road or railroad')
  end

  desc 'Populate all reference data'
  task :populate_reference_data => [:populate_locations, :populate_countries, :populate_continents, :populate_location_types] do
    Rake::Task[ "blavel:reindex_location_search" ].invoke
  end
  
  desc 'Refresh locations and countries from Geonames'
  task :refresh_locations => [:download_locations, :download_countries, :populate_locations, :populate_countries, :populate_continents, :populate_location_types] do
    Rake::Task[ "blavel:reindex_location_search" ].invoke
  end

  desc 'Populate all reference data first time'
  task :populate_reference_data => [:populate_locations, :populate_countries, :populate_continents, :populate_location_types] do
    Rake::Task[ "blavel:index_location_search" ].invoke
  end

  desc 'Refresh locations and countries from Geonames first time'
  task :refresh_locations_first_time => [:download_locations, :download_countries, :populate_locations, :populate_countries, :populate_continents, :populate_location_types] do
    Rake::Task[ "blavel:index_location_search" ].invoke
  end
end
