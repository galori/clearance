require 'rails_helper'

describe ClearanceBatchesController do
  describe '#index' do
    let!(:batches) {create_list(:clearance_batch, 5)}

    it 'should assign @batches to all batches' do
      get :index
      expect(assigns[:batches]).to eq(batches)
    end
  end
end