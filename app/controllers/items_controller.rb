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
    @group_by = params[:group_by] || 'status'

    if @group_by == 'status'
      @groups = Item.order(:status).group_by{|i| i.status}
    else
      @groups = Item.order(:clearance_batch_id).group_by{|i| i.clearance_batch_id}
    end
    render :template => 'items/index'
  end
end