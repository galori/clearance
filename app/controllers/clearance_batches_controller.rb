class ClearanceBatchesController < ApplicationController

  def index
    @clearance_batches  = ClearanceBatch.all
  end

  def create

    clearancing_service = ClearancingService.new(uploaded_file)
    status = clearancing_service.process
    batch    = status.batch

    success_messages = []
    error_messages = []

    if status.counts[:success] > 0
      success_messages << "#{status.counts[:success]} items clearanced in batch #{batch.id}"
    else
      error_messages << "No new clearance batch was added"
    end

    if status.counts[:error] > 0
      error_messages << "#{status.counts[:error]} item ids raised errors and were not clearanced"
    end

    flash[:notice_2] = success_messages.join('<br/>') if success_messages.count > 0
    flash[:alert_2] = error_messages.join('<br/>') if error_messages.count > 0  

    # to refactor

    alert_messages     = []
    if batch.persisted?
      flash[:notice]  = "#{batch.items.count} items clearanced in batch #{batch.id}"
    else
      alert_messages << "No new clearance batch was added"
    end
    if status.errors.any?
      alert_messages << "#{status.errors.count} item ids raised errors and were not clearanced"
      status.errors.each {|error| alert_messages << error }
    end
    flash[:alert] = alert_messages.join("<br/>") if alert_messages.any?
    redirect_to action: :index
  end
private
  def uploaded_file
    params[:csv_batch_file].tempfile
  end
end
