require 'rails_helper'

describe 'Clearance Batch Routing Spec' do
  describe 'GET /' do
    it 'should route to clearance_batches#index' do
      expect(get(root_path)).to route_to('clearance_batches#index')
    end
  end

  describe 'POST /clearance_batches' do
    it 'should route to clearance_batches#create' do
      expect(post(clearance_batches_path)).to route_to('clearance_batches#create')
    end
  end

  describe '/clearance_batches/:clearance_batch_id/items' do
    it 'should route to items#index' do
      expect(get(clearance_batch_items_path(123))).to route_to('items#index', :clearance_batch_id => '123')
    end
  end
end