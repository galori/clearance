require 'rails_helper'

describe 'Items Spec', :js => true do

  let!(:dress_style) {create(:style, :type => 'Dress', :name => 'Long Black Dress')}
  let!(:dress_items) {create_list(:item, 10, :style => dress_style, :status => 'clearanced')}

  let!(:blue_jeans_style) {create(:style, :name => 'Blue Jeans')}
  let!(:jeans_items) {create_list(:item, 10, :style => blue_jeans_style, :status => 'sellable')}
  it 'should allow browsing all items' do
    visit '/'
    click_link 'Browse Items'

    expect(page).to have_content('Grouped by Status')

    within 'div#clearanced' do
      expect(page).to have_content('Clearanced')
      expect(page).to have_content('Long Black Dress')
    end

    within 'div#sellable' do
      expect(page).to have_content('Sellable')
      expect(page).to have_content('Blue Jeans')
    end
  end
end