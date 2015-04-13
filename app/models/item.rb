class Item < ActiveRecord::Base

  validate :clearance_price_is_not_too_low, :if => :price_sold_changed? && :status_changed?, :on => :update
  validate :item_status_allows_clearancing, :if => :sold_at_changed?, :on => :update

  CLEARANCE_PRICE_PERCENTAGE  = BigDecimal.new("0.75")

  belongs_to :style
  belongs_to :clearance_batch
  alias_attribute :batch, :clearance_batch

  attr_accessor :being_clearanced

  scope :sellable, -> { where(status: 'sellable') }

  def clearance!
    Rails.logger.info "in clearance!"
    self.being_clearanced = true
    Rails.logger.info "self.being_clearanced = #{self.being_clearanced}"
    self.status = 'clearanced'
    self.price_sold = clearance_price
    self.sold_at = Time.zone.now
    self.save
  end

  def sellable?
    self.status == 'sellable'
  end

private

  def clearance_price
    self.style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE
  end

  def minimum_clearance_price
    self.style.minimum_clearance_price
  end

  def clearance_price_is_not_too_low
    if self.status == 'clearanced' && self.price_sold < minimum_clearance_price
      errors.add(:price_sold,"#{formatted_price} is too low for Item of style #{style.type}")
    end
  end

  def item_status_allows_clearancing
    Rails.logger.info('in item_status_allows_clearancing')
    previous_status = self.attribute_was('status')


    if previous_status != 'sellable' && self.status == 'clearanced'
      Rails.logger.info('adding error')
      errors.add(:status,"#{previous_status} can not be clearanced again")
    end
  end

  def formatted_price
    # Using number_to_currency helper here Violates MVC. We're ok with it here.
    ActionController::Base.helpers.number_to_currency(price_sold)
  end
end
