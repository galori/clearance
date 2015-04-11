require 'rails_helper'

describe 'Items Spec', :js => true do
  let!(:blue_jeans_style) {create(:style, :name => 'Blue Jeans')}
  let!(:items) {create_list(:item, 10, :style => blue_jeans_style)}
  it 'should allow browsing all items' do
    visit '/'
    click_link 'Browse Items'
    expect(page).to have_content('Blue Jeans')
  end
end