require 'rails_helper'

describe Style do
  describe '.minimum_clearance_price' do
    describe 'For a dress' do
      let(:style) {create(:style, :type => 'Dress').minimum_clearance_price}
      it 'should return $5.00' do
        expect(style).to eq(5.00)
      end
    end
    describe 'For Pants' do
      let(:style) {create(:style, :type => 'Pants').minimum_clearance_price}
      it 'should return $5.00' do
        expect(style).to eq(5.00)
      end
    end
    describe 'For anything else' do
      let(:style) {create(:style, :type => 'Scarf').minimum_clearance_price}
      it 'should return $2.00' do
        expect(style).to eq(2.00)
      end
    end
  end

end
