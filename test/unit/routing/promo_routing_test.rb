require 'test_helper'

class PromoRoutingTest < ActiveSupport::TestCase
  def test_promo
    assert_generates "/home", 
      :controller => 'promo', 
      :action => 'home'
    assert_recognizes({ :controller => 'promo', 
      :action => 'home' },
      "/home")
  end
  
  def test_sitemap
    assert_generates "/sitemap.xml", 
      :controller => 'promo', 
      :action => 'sitemap'
    assert_recognizes({ :controller => 'promo', 
      :action => 'sitemap' },
      "/sitemap.xml")
  end
  
  def test_doco
    assert_generates "/opencode", 
      :controller => 'promo', 
      :action => 'doco'
    assert_recognizes({ :controller => 'promo', 
      :action => 'doco' },
      "/opencode")
  end
end
