namespace :blavel do
  namespace :migrate_legacy do
    task :prepare => :environment do
      Rake::Task[ "db:migrate:reset" ].invoke
      Rake::Task[ "db:migrate" ].invoke
      Rake::Task[ "blavel:populate_reference_data" ].invoke
    end
    
    task :users => :environment do
      User.delete_all
      
      legacy_users = LegacyUser.find(:all,
        :conditions => 'dateActivated is not null')
    
      i = 0
    
      legacy_users.each do |u|
        new_user = User.new
      
        new_user.login = u.userName
        new_user.email = u.emailAddress
        new_user.gender = u.gender
        new_user.about_me = u.profileMessage
        new_user.password = u.password
        new_user.password_confirmation = new_user.password
        new_user.created_at = u.dateJoined
        new_user.activated_at = u.dateActivated
      
        if new_user.save
          puts "Successfully migrated user #{i += 1} of #{legacy_users.length}."
        else
          puts "Picture #{i += 1} of #{legacy_users.length} not migrated. (user name: #{u.userName})"
        end
      end
    end
    
    task :posts => [:environment, :users] do
      Post.delete_all
      Post.connection.add_column :posts, :legacy_id, :integer
      
      legacy_posts = LegacyPost.find(:all,
        :conditions => 'dateDeleted is null')
      sanitizer = HTML::WhiteListSanitizer.new
    
      i = 0
    
      legacy_posts.each do |p|
        new_post = Post.new
        owner = User.find_by_login(p.userName)
      
        new_post.user = owner
        new_post.title = p.title
        new_post.content = sanitizer.sanitize(p.content, :tags => %w(strong em ul ol li a br p))
        new_post.created_at = p.dateCreated
        new_post.updated_at = p.dateUpdated
        new_post.legacy_id = p.id
      
        if p.placeId != 0
          location = Location.find(p.placeId)
          new_post.locations.push(location)
        end
      
        if new_post.save
          puts "Successfully migrated post #{i += 1} of #{legacy_posts.length}."
        else
          puts "Picture #{i += 1} of #{legacy_posts.length} not migrated. (legacy id: #{p.id})"
        end
      end
    end
    
    task :pictures => [:environment, :posts] do
      Picture.destroy_all
      
      temp_picture_file = "#{File.expand_path(RAILS_ROOT)}/db/picture.jpg"
    
      legacy_pictures = LegacyPicture.find(:all,
        :conditions => 'dateDeleted is null')
    
      i = 0
    
      legacy_pictures.each do |p|
        new_picture = Picture.new
        parent_post = Post.find_by_legacy_id(p.entryId)
      
        save_remote_file('www.blavel.com', p.imagePath, temp_picture_file)
        picture_data = uploaded_file(temp_picture_file, 'image/jpeg')
           
        new_picture.post = parent_post
        new_picture.uploaded_data = picture_data
        new_picture.content_type = 'image/jpeg'
        new_picture.title = p.title
        new_picture.description = p.description
        new_picture.created_at = p.dateCreated
        new_picture.updated_at = p.dateUpdated
        
        if parent_post.pictures.blank?
          new_picture.sequence = 1
        else
          result = Picture.connection.select_all("SELECT MAX(sequence) AS last_number FROM pictures WHERE post_id = #{parent_post.id}")
          new_picture.sequence = result[0]['last_number'].to_i + 1
        end
      
        if new_picture.save
          puts "Successfully migrated picture #{i += 1} of #{legacy_pictures.length}."
        else
          puts "Picture #{i += 1} of #{legacy_pictures.length} not migrated. (legacy id: #{p.id})"
        end
      end
    
      File.delete(temp_picture_file)
    end
    
    task :profile_pictures do
      ProfilePicture.destroy_all
    
      temp_picture_file = "#{File.expand_path(RAILS_ROOT)}/db/picture.jpg"
    
      legacy_users = LegacyUser.find(:all,
        :conditions => 'dateActivated is not null and profilePicPath is not null')
    
      i = 0
    
      legacy_users.each do |u|
        migrated_user = User.find_by_login(u.userName)
        new_picture = ProfilePicture.new
      
        save_remote_file('www.blavel.com', u.profilePicPath, temp_picture_file)
        picture_data = uploaded_file(temp_picture_file, 'image/jpeg')
           
        new_picture.user = migrated_user
        new_picture.uploaded_data = picture_data
        new_picture.content_type = 'image/jpeg'
            
        if new_picture.save
          puts "Successfully migrated profile picture #{i += 1} of #{legacy_users.length}."
        else
          puts "Picture #{i += 1} of #{legacy_users.length} not migrated. (user name: #{u.userName})"
        end
      end
    
      File.delete(temp_picture_file)
    end
    
    task :notes => [:environment, :users, :posts] do
      Note.delete_all
    
      legacy_notes = LegacyNote.find(:all,
        :conditions => 'deleted = 0')
    
      i = 0
    
      legacy_notes.each do |n|
        new_note = Note.new
        note_leaver = User.find_by_login(n.userName)
        post_left_on = Post.find_by_legacy_id(n.entryId)
      
        new_note.user = note_leaver
        new_note.post = post_left_on
        new_note.content = n.content
        new_note.created_at = n.dateCreated
      
        if new_note.save
          puts "Successfully migrated note #{i += 1} of #{legacy_notes.length}."
        else
          puts "Note #{i += 1} of #{legacy_notes.length} not migrated. (legacy id: #{n.id}"
        end
      end
    end
    
    task :mailees => [:environment, :users] do
      Mailee.delete_all
    
      legacy_mailees = LegacyMailee.find(:all)
    
      i = 0
    
      legacy_mailees.each do |m|
        new_mailee = Mailee.new
        owner = User.find_by_login(m.userName)
      
        new_mailee.user = owner
        new_mailee.email = m.emailAddress
      
        if new_mailee.save
          puts "Successfully migrated mailee #{i += 1} of #{legacy_mailees.length}."
        else
          puts "Mailee #{i += 1} of #{legacy_mailees.length} not migrated. (email: #{m.emailAddress}"
        end
      end
    end
    
    task :all => [:prepare, :users, :posts, :pictures, :profile_pictures, :notes, :mailees] do
      Post.connection.remove_column :posts, :legacy_id
    end
  end
end