require 'csv'
require 'ostruct'

class ClearancingService

  def initialize(file_or_ids)
    @file_or_ids = file_or_ids
  end

  def process
    each_item_id do |item_id|
      success, error_message, item = perform_item_clearance item_id

      if success
        add_good_clearance item
      else
        add_error error_message
      end
    end

    status
  end

private

  def perform_item_clearance(item_id)

    success, error = can_be_clearanced?(item_id)

    if !success
      return false,error,nil
    else
      item = Item.find(item_id)

      result = item.clearance!

      if result
        return true,nil,item
      else
        return false,formatted_error(item),item
      end
    end
  end


  def add_error(messages)
    status.errors << messages
    status.counts[:error] += 1
  end

  def formatted_error(item)
    item.errors.full_messages.map do |message|
      "Item id #{item.id} could not be clearanced: #{message}"
    end.join(", ")
  end

  def add_good_clearance item
    batch.items << item
    status.counts[:success] += 1
  end

  def can_be_clearanced?(id)
    invalid_id_error(id) || nonexistant_item_error(id) || valid
  end

  def invalid_id_error(id)
    [false,"Item id #{id} is not valid"] if !valid_id?(id)
  end

  def nonexistant_item_error(id)
    [false,"Item id #{id} could not be found"] if !Item.exists?(id)
  end

  def valid
    [true,nil]
  end

  def batch
    status.batch.save! if !status.batch.persisted?
    status.batch
  end

  def status
    @status ||= OpenStruct.new(
      batch: ClearanceBatch.new,
      errors: [],
      counts: {
        success: 0,
        error: 0
      })
  end

  def valid_id?(value)
    value.to_i > 0
  end

  def each_item_id
    if @file_or_ids.is_a?(String)
      @file_or_ids.split(" ").each do |id|
        yield id
      end
    else
      CSV.foreach(@file_or_ids, headers: false) do |row|
        yield row[0].to_i
      end
    end
  end

  def each_potential_clearance_item
    status.valid_item_ids.each do |id|
      yield Item.find(id)
    end
  end
end
