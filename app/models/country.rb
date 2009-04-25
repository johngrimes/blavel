class Country < ActiveRecord::Base
  set_primary_key :code
  has_many :locations, :foreign_key => 'country_code'   # Locations that are within this country
  belongs_to :location    # Location that represents this country
  belongs_to :continent
end
