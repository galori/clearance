require 'rails_helper'

describe ItemsController do
  describe '#index' do

    describe 'Displaying Batches' do
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
        let!(:batch1) {create(:clearance_batch)}
        let!(:batch2) {create(:clearance_batch)}

        let!(:item1) {create(:item, :status => 'clearanced', :batch => batch2)}
        let!(:item2) {create(:item, :status => 'sellable', :batch => batch1)}

        it 'should not assign @batch' do
          get :index
          expect(assigns[:batch]).to eq(nil)
        end

        it 'should default @group_by to status' do
          get :index
          expect(assigns[:group_by]).to eq('status')
        end

        describe 'grouping by Status' do
          it 'should assign @group_by to status' do
            get :index
            expect(assigns[:group_by]).to eq('status')
          end

          it 'should @groups to items grouped by status' do
            get :index
            expect(assigns[:groups]).to eq({'clearanced' => [item1], 'sellable' => [item2]})
          end
        end

        describe 'grouping by Clearance Batches' do
          it 'should assign @group_by to clearance_batch' do
            get :index, :group_by => 'clearance_batch'
            expect(assigns[:group_by]).to eq('clearance_batch')
          end

          it 'should @groups to items grouped by status' do
            get :index, :group_by => 'clearance_batch'
            expect(assigns[:groups]).to eq({1 => [item2], 2 => [item1]})
          end
        end
      end
    end


  end
end