class AbstractLegacyRecord < ActiveRecord::Base
  establish_connection 'legacy'
  self.abstract_class = true
end