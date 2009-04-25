namespace :blavel do
  namespace :db do
    desc "Backup production database using mysqldump"
    task :backup do
      system "#{RAILS_ROOT}/../../shared/system/db/backup/backup.sh"
    end
  end
end