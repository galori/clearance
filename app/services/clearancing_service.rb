require 'csv'
require 'ostruct'

class ClearancingService

  def initialize(file)
    @file = file
  end

  def process
    item_ids_each do |potential_item_id|
      clearancing_error = what_is_the_clearancing_error?(potential_item_id)
      if clearancing_error
        status.errors << clearancing_error
      else
        status.item_ids_to_clearance << potential_item_id
      end
    end

    clearance_items!(status) 
  end

private

  def item_ids_each
    CSV.foreach(@file, headers: false) do |row|
      yield row[0].to_i
    end
  end

  def clearance_items!(status)
    if status.item_ids_to_clearance.any? 
      status.batch.save!
      status.item_ids_to_clearance.each do |item_id|
        item = Item.find(item_id)
        if item.clearance!
          status.batch.items << item
        else
          item.errors.full_messages.each do |message|
            status.errors << "Item id #{item_id} could not be clearanced: #{message}"
          end
        end
      end
      status.counts[:success] = status.batch.items.count
    end
    status.counts[:error] = status.errors.count
    status
  end

  def what_is_the_clearancing_error?(potential_item_id)
    if potential_item_id.blank? || potential_item_id == 0 || !potential_item_id.is_a?(Integer)
      return "Item id #{potential_item_id} is not valid"      
    end
    if Item.where(id: potential_item_id).none?
      return "Item id #{potential_item_id} could not be found"      
    end
    if Item.sellable.where(id: potential_item_id).none?
      return "Item id #{potential_item_id} could not be clearanced"
    end

    return
  end

  def status
    @status ||= OpenStruct.new(
      batch: ClearanceBatch.new,
      item_ids_to_clearance: [],
      errors: [],
      counts: {
        success: 0,
        error: 0
      })
  end

end
