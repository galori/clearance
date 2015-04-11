class ItemsController < ApplicationController

  def index
    if (batch_id = params[:clearance_batch_id])
      @batch = ClearanceBatch.find(batch_id)
      @items = @batch.items
    else
      @items = Item.all
    end
  end

end