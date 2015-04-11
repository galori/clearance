require 'rails_helper'

describe 'Item Routing Spec' do
  describe 'GET /items' do
    it 'should route to items#index' do
      expect(get(items_path)).to route_to('items#index')
    end
  end
end