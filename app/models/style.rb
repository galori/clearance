class Style < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  has_many :items

  def minimum_clearance_price
    type.in?(['Pants','Dress']) ? 5.00 : 2.00
  end
end
