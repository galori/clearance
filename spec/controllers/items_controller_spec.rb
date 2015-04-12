require 'rails_helper'

describe ItemsController do
  describe '#index' do

    describe 'Batches' do
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
    end

    describe 'Item browsing' do
      describe 'when the clearance_batch_id is not passed in' do
        let!(:item1) {create(:item, :status => 'clearanced')}
        let!(:item2) {create(:item, :status => 'sellable')}

        it 'should not assign @batch' do
          get :index
          expect(assigns[:batch]).to eq(nil)
        end

        it 'should default @group_by to status' do
          get :index
          expect(assigns[:group_by]).to eq('status')
        end

        it 'should assign @groups to groups of items by the grouping' do
          get :index
          expect(assigns[:groups]).to eq({'clearanced' => [item1], 'sellable' => [item2]})
        end
      end
    end


  end
end