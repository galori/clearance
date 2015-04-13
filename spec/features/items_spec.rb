require 'rails_helper'

describe 'Items Spec', :js => true do

  let!(:batch_1) {create(:clearance_batch)}
  let!(:batch_2) {create(:clearance_batch)}

  let!(:dress_style) {create(:style, :type => 'Dress', :name => 'Long Black Dress')}
  let!(:dress_items) {create_list(:item, 10, :style => dress_style, :status => 'clearanced', :batch => batch_2)}

  let!(:blue_jeans_style) {create(:style, :name => 'Blue Jeans')}
  let!(:jeans_items) {create_list(:item, 10, :style => blue_jeans_style, :status => 'sellable', :batch => batch_1)}

  it 'should allow browsing all items' do
    visit '/'
    click_link 'Browse Items'

    expect(page).to have_content('Grouped by Status')

    within 'div#group-clearanced' do
      expect(page).to have_content('Long Black Dress')
    end

    within 'div#group-sellable' do
      expect(page).to have_content('Blue Jeans')
    end

    click_link 'Group By Clearance Batch'

    expect(page).to have_content('Grouped by Clearance Batch')

    within 'div#group-1' do
      expect(page).to have_content('Blue Jeans')
    end

    within 'div#group-2' do
      expect(page).to have_content('Long Black Dress')
    end


  end
end