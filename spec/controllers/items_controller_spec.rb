require 'rails_helper'

describe ItemsController do
  describe '#index' do

    let!(:batch) {create(:clearance_batch)}
    let!(:items_in_batch) {create_list(:item, 3, :clearance_batch => batch)}
    let!(:items_not_in_batch) {create_list(:item, 2)}

    describe 'when the clearance_batch_id is passed in' do
      it 'should assign @items to all the items in the batch' do
        get :index, :clearance_batch_id => batch.id
        expect(assigns[:items]).to eq(items_in_batch)
      end

      it 'should assign @batch' do
        get :index, :clearance_batch_id => batch.id
        expect(assigns[:batch]).to eq(batch)
      end
    end

    describe 'when the clearance_batch_id is not passed in' do
      it 'should assign @items to all items' do
        get :index
        expect(assigns[:items]).to eq(items_in_batch + items_not_in_batch)
      end

      it 'should not assign @batch' do
        get :index
        expect(assigns[:batch]).to eq(nil)
      end
    end


  end
end