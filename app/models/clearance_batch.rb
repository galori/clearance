class ClearanceBatch < ActiveRecord::Base

  has_many :items, :counter_cache => true

end
