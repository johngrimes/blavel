ActionController::Routing::Routes.draw do |map|
  # Notes
  map.note_post "/posts/:post_id/note",
    :controller => 'notes',
    :action => 'create',
    :conditions => { :method => :post }
  map.note_picture "/pictures/:picture_id/note",
    :controller => 'notes',
    :action => 'create',
    :conditions => { :method => :post }
  map.destroy_note "/notes/:id/remove",
    :controller => 'notes',
    :action => 'destroy',
    :conditions => { :method => :delete }

  # Posts
  map.show_post_long "/travel-blogs/:country_code.:country_name/:location_id.:location_name/:id",
    :controller => 'posts',
    :action => 'show',
    :requirements => { :location_id => /\d+/, :id => /\d+/ }
  map.show_post_medium "/travel-blogs/:location_id.:location_name/:id",
    :controller => 'posts',
    :action => 'show',
    :requirements => { :location_id => /\d+/, :id => /\d+/ }
  map.show_post_short "/travel-blogs/:id",
    :controller => 'posts',
    :action => 'show',
    :requirements => { :id => /\d+/ }
  map.new_post "/posts/new",
    :controller => 'posts',
    :action => 'new'
  map.create_post "/posts",
    :controller => 'posts',
    :action => 'create',
    :conditions => { :method => :post }
  map.edit_post "/posts/:id/edit",
    :controller => 'posts',
    :action => 'edit',
    :requirements => { :id => /\d+/ }
  map.update_post "/posts/:id",
    :controller => 'posts',
    :action => 'update',
    :requirements => { :id => /\d+/ },
    :conditions => { :method => :put }
  map.destroy_post "/posts/:id",
    :controller => 'posts',
    :action => 'destroy',
    :requirements => { :id => /\d+/ },
    :conditions => { :method => :delete }

  # Pictures
  map.show_picture "/pictures/:id",
    :controller => 'pictures',
    :action => 'show',
    :requirements => { :id => /\d+/ },
    :conditions => { :method => :get }
  map.show_all_pictures "/posts/:post_id/pictures",
    :controller => 'pictures',
    :action => 'show_all',
    :requirements => { :post_id => /\d+/ },
    :conditions => { :method => :get }
  map.add_pictures '/posts/:post_id/pictures/add',
    :controller => 'pictures',
    :action => 'add',
    :requirements => { :post_id => /\d+/ }
  map.add_pictures_new_post '/posts/new/pictures/add',
    :controller => 'pictures',
    :action => 'add',
    :new_post => true
  map.create_picture '/posts/:post_id/pictures',
    :controller => 'pictures',
    :action => 'create',
    :requirements => { :post_id => /\d+/ },
    :conditions => { :method => :post }
  map.edit_pictures '/posts/:post_id/pictures/edit',
    :controller => 'pictures',
    :action => 'edit',
    :requirements => { :post_id => /\d+/ }
  map.update_pictures '/posts/:post_id/pictures',
    :controller => 'pictures',
    :action => 'update',
    :requirements => { :post_id => /\d+/ },
    :conditions => { :method => :put }
  map.destroy_picture '/pictures/:id',
    :controller => 'pictures',
    :action => 'destroy',
    :requirements => { :id => /\d+/ },
    :conditions => { :method => :delete }

  # Mailees
  map.show_mailing_list "/posts/:post_id/mailing",
    :controller => 'mailees',
    :action => 'show',
    :conditions => { :method => :get }
  map.send_mailing_list "/posts/:post_id/mailing",
    :controller => 'mailees',
    :action => 'send_to',
    :conditions => { :method => :post }
  map.add_mailee "/:user_login/mailees",
    :controller => 'mailees',
    :action => 'add',
    :conditions => { :method => :post }
  map.destroy_mailee "/:user_login/mailees",
    :controller => 'mailees',
    :action => 'destroy',
    :conditions => { :method => :delete }

  # Locations
  map.location_search "/locations/search",
    :controller => 'locations',
    :action => 'search'
  map.location_search_query "/locations/search/:query",
    :controller => 'locations',
    :action => 'search'
  map.location_map "/map/:post_location_ids/:picture_location_ids",
    :controller => 'locations',
    :action => 'map',
    :requirements => { :post_location_ids => /[\d,]+/, :picture_location_ids => /[\d,]+/ }
  map.picture_map "/map//:picture_location_ids",
    :controller => 'locations',
    :action => 'map',
    :requirements => { :picture_location_ids => /[\d,]+/ }
  map.post_map "/map/:post_location_ids",
    :controller => 'locations',
    :action => 'map',
    :requirements => { :post_location_ids => /[\d,]+/ }

  # Browse
  map.browse '/browse',
    :controller => 'browse',
    :action => 'index'
  map.browse_page '/browse/page.:page',
    :controller => 'browse',
    :action => 'index'
  map.browse_continent "/browse/:continent_code.:continent_name",
    :controller => 'browse',
    :action => 'continent',
    :requirements => { :continent_code => /[A-Z]+/ }
  map.browse_continent_page "/browse/:continent_code.:continent_name/page.:page",
    :controller => 'browse',
    :action => 'continent',
    :requirements => { :continent_code => /[A-Z]+/ }
  map.browse_country "/browse/:continent_code.:continent_name/:country_code.:country_name",
    :controller => 'browse',
    :action => 'country',
    :requirements => { :continent_code => /[A-Z]+/,
                       :country_code => /[A-Z]+/  }
  map.browse_country_page "/browse/:continent_code.:continent_name/:country_code.:country_name/page.:page",
    :controller => 'browse',
    :action => 'country',
    :requirements => { :continent_code => /[A-Z]+/,
                       :country_code => /[A-Z]+/  }
  map.browse_location "/browse/:continent_code.:continent_name/:country_code.:country_name/:location_id.:location_name",
    :controller => 'browse',
    :action => 'location',
    :requirements => { :continent_code => /[A-Z]+/,
                       :country_code => /[A-Z]+/,
                       :location_id => /\d+/ }
  map.browse_location_page "/browse/:continent_code.:continent_name/:country_code.:country_name/:location_id.:location_name/page.:page",
    :controller => 'browse',
    :action => 'location',
    :requirements => { :continent_code => /[A-Z]+/,
                       :country_code => /[A-Z]+/,
                       :location_id => /\d+/ }
  map.browse_location_no_country "/browse/:location_id.:location_name",
    :controller => 'browse',
    :action => 'location',
    :requirements => { :location_id => /\d+/ }
  map.browse_location_no_country_page "/browse/:location_id.:location_name/page.:page",
    :controller => 'browse',
    :action => 'location',
    :requirements => { :location_id => /\d+/ }

  # Facebook
  map.fb_index "/facebook",
    :controller => 'facebook',
    :action => 'index'
  map.fb_tab "/facebook/tab",
    :controller => 'facebook',
    :action => 'tab'
  map.new_fb_link "/facebook/link",
    :controller => 'facebook',
    :action => 'new_link',
    :conditions => { :method => :get }
  map.create_fb_link "/facebook/link",
    :controller => 'facebook',
    :action => 'create_link',
    :conditions => { :method => :post }

  # Help
  map.help "/help/:action",
    :controller => 'help'

  # Promo
  map.promo '/home',
    :controller => 'promo',
    :action => 'home'
  map.sitemap "/sitemap.xml",
    :controller => 'promo',
    :action => 'sitemap'
  map.doco "/opencode",
    :controller => 'promo',
    :action => 'doco'

  # Sessions
  map.login '/login',
    :controller => 'sessions',
    :action => 'new',
    :conditions => { :method => :get }
  map.create_session '/login',
    :controller => 'sessions',
    :action => 'create',
    :conditions => { :method => :post }
  map.logout '/logout',
    :controller => 'sessions',
    :action => 'destroy'

  # Messages
  map.show_message "/messages/:id",
    :controller => 'messages',
    :action => 'show',
    :requirements => { :id => /\d+/ }
  map.new_message "/messages/new/:user_login",
    :controller => 'messages',
    :action => 'new'
  map.create_message '/messages',
    :controller => 'messages',
    :action => 'create',
    :conditions => { :method => :post }
  map.manage_messages '/messages',
    :controller => 'messages',
    :action => 'manage',
    :conditions => { :method => :get }
  map.mark_message_read_url '/messages/read',
    :controller => 'messages',
    :action => 'mark_as_read',
    :conditions => { :method => :post }
  map.message_convo "/messages/:id/convo",
    :controller => 'messages',
    :action => 'convo'

  # Users
  map.join '/join',
    :controller => 'users',
    :action => 'new'
  map.create_user '/users',
    :controller => 'users',
    :action => 'create',
    :conditions => { :method => :post }
  map.activation_instructions "/:user_login/activate",
    :controller => 'users',
    :action => 'activation'
  map.activate '/activate/:activation_code',
    :controller => 'users',
    :action => 'activate',
    :activation_code => nil
  map.user_profile "/:user_login",
    :controller => 'users',
    :action => 'show'
  map.user_profile_page "/:user_login/page.:page",
    :controller => 'users',
    :action => 'show',
    :requirements => { :page => /\d+/ }
  map.edit_profile "/:user_login/edit",
    :controller => 'users',
    :action => 'edit',
    :conditions => { :method => :get }
  map.update_profile "/:user_login/edit",
    :controller => 'users',
    :action => 'update',
    :conditions => { :method => :put }
  map.upload_picture "/:user_login/picture/upload",
    :controller => 'users',
    :action => 'upload_picture',
    :conditions => { :method => :get }
  map.update_picture "/:user_login/picture/upload",
    :controller => 'users',
    :action => 'update_picture',
    :conditions => { :method => :put }

  # Follows
  map.follow "/:user_login/follow",
    :controller => 'follows',
    :action => 'follow',
    :conditions => { :method => :post }
  map.unfollow "/:user_login/unfollow",
    :controller => 'follows',
    :action => 'unfollow',
    :conditions => { :method => :delete }
  map.show_all_followers "/:user_login/followers",
    :controller => 'follows',
    :action => 'show_all_followers'
  map.show_all_followees "/:user_login/followees",
    :controller => 'follows',
    :action => 'show_all_followees'

  # Feed
  map.user_rss_feed "/:user_login/feed",
    :controller => 'feeds',
    :action => 'rss'
  map.everybody_feed "/feed/everybody",
    :controller => 'feeds',
    :action => 'feed',
    :everybody => true
  map.base '',
    :controller => 'feeds',
    :action => 'feed'
end
