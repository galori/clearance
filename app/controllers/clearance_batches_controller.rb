class ClearanceBatchesController < ApplicationController

  def index
    @batches  = ClearanceBatch.all
  end

  def new

  end

  def create
    clearancing_service = ClearancingService.new(uploaded_file)
    status = clearancing_service.process

    if status.counts[:success] > 0
      add_success "#{status.counts[:success]} items clearanced in batch #{status.batch.id}"
    else
      add_error "No new clearance batch was added"
    end

    if status.counts[:error] > 0
      add_error "#{status.counts[:error]} item ids raised errors and were not clearanced"
      add_error status.errors
    end

    index
    render action: :index
  end

private

  def uploaded_file
    if params[:'file-field']
      params[:'file-field'].tempfile
    else
      params[:item_ids]
    end
  end

  def add_success(messages)
    success_messages << messages
    success_messages.flatten
  end

  def add_error(messages)
    error_messages << messages
    error_messages.flatten
  end

  def success_messages
    @success_messages ||= []
  end

  def error_messages
    @error_messages ||= []
  end
end
