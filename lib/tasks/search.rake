namespace :blavel do
  desc "Reindex Sphinx location search index"
  task :reindex_location_search do
    if RAILS_ENV == 'production' 
      system "sudo /usr/local/bin/indexer --all --rotate --config #{RAILS_ROOT}/config/sphinx/sphinx.#{RAILS_ENV}.conf"
    else
      system "indexer --all --rotate --config #{RAILS_ROOT}/config/sphinx/sphinx.#{RAILS_ENV}.conf"
    end
  end
end