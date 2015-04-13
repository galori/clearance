class AddCounterCacheToClearanceBatches < ActiveRecord::Migration
  def change
    add_column :clearance_batches, :items_count, :integer

    ClearanceBatch.find_each.each do |b|
      b.update_attribute :items_count, b.items.size
    end
  end
end
