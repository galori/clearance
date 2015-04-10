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

  def clearance_items!(status)
    each_potential_clearance_item do |item|
      if item.clearance!
        add_good_clearance item
      else
        add_errors item
      end
    end
    status.counts[:error] = status.errors.count
    status
  end

  def add_errors(item)
    status.errors << formatted_errors(item)
    status.errors.flatten!
  end

  def formatted_errors(item)
    item.errors.full_messages.map do |message|
      "Item id #{item.id} could not be clearanced: #{message}"
    end
  end

  def add_good_clearance item
    batch.items << item
    status.counts[:success] += 1
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

  def item_ids_each
    CSV.foreach(@file, headers: false) do |row|
      yield row[0].to_i
    end
  end

  def each_potential_clearance_item
    status.valid_item_ids.each do |id|
      yield Item.find(id)
    end
  end
end
