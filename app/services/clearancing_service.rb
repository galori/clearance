require 'csv'
require 'ostruct'

class ClearancingService

  def initialize(file)
    @file = file
  end

  def process
    item_ids_each do |item_id|
      valid, error = can_be_clearanced?(item_id)

      if valid
        status.errors << error
      else
        status.item_ids_to_clearance << item_id
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
      status.item_ids_to_clearance.each do |item_id|
        item = Item.find(item_id)
        if item.clearance!
          batch.items << item
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

  def can_be_clearanced?(potential_item_id)
    if potential_item_id.blank? || potential_item_id == 0 || !potential_item_id.is_a?(Integer)
      error =  "Item id #{potential_item_id} is not valid"
    elsif Item.where(id: potential_item_id).none?
      error = "Item id #{potential_item_id} could not be found"
    elsif Item.sellable.where(id: potential_item_id).none?
      error = "Item id #{potential_item_id} could not be clearanced"
    end

    return !!error, error
  end

  def batch
    status.batch.save! if !status.batch.persisted?
    status.batch
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
