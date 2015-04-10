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
        status.valid_item_ids << item_id
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
    status.valid_item_ids.each do |item_id|
      item = Item.find(item_id)
      if item.clearance!
        batch.items << item
        status.counts[:success] += 1
      else
        item.errors.full_messages.each do |message|
          status.errors << "Item id #{item_id} could not be clearanced: #{message}"
        end
      end
    end
    status.counts[:error] = status.errors.count
    status
  end

  def can_be_clearanced?(id)
    if !positive_integer?(id)
      error =  "Item id #{id} is not valid"
    else

      item = Item.where(:id => id).first

      if !item
        error = "Item id #{id} could not be found"
      elsif !item.sellable?
        error = "Item id #{id} could not be clearanced"
      end
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
      valid_item_ids: [],
      errors: [],
      counts: {
        success: 0,
        error: 0
      })
  end

  def positive_integer?(value)
    value.to_i > 0
  end
end
