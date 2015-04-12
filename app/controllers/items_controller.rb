class ItemsController < ApplicationController

  def index
    if (batch_id = params[:clearance_batch_id])
      render_items_in_batch(batch_id)
    else
      render_all_items
    end
  end

  def render_items_in_batch(batch_id)
    @batch = ClearanceBatch.find(batch_id)
    @items = @batch.items
    render :template => 'items/items_in_clearance_batch'
  end

  def render_all_items
    @group_by = 'status'
    @groups = Item.all.group_by{|i| i.status}
    render :template => 'items/index'
  end
end