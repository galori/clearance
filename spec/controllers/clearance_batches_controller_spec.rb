require 'rails_helper'

describe ClearanceBatchesController do
  describe '#index' do
    let!(:batches) {create_list(:clearance_batch, 5)}

    it 'should assign @batches to all batches' do
      get :index
      expect(assigns[:batches]).to eq(batches)
    end
  end

  describe '#create' do

    describe "Clearancing Service" do
      it 'should pass the IDs to the clearancing service and pass the errors back' do
        batch = double('batch', :id => 1)
        clearancing_status = double('status', :counts => {:success => 1, :error => 0}, :batch => batch)
        clearancing_service = instance_double('ClearancingService', :process => clearancing_status)
        expect(ClearancingService).to receive(:new).with('1,2,3').and_return(clearancing_service)

        post :create, :item_ids => '1,2,3'

        expect(clearancing_service).to have_received(:process)
        expect(assigns[:success_messages]).to eq(["1 items clearanced in batch 1"])
        expect(assigns[:error_messages]).to be_nil
      end
    end
  end

  describe '#new' do
    it 'should exist' do
      get :new
      expect(response).to be_successful
    end
  end
end