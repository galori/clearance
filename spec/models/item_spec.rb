require 'rails_helper'

describe Item do
  describe ".clearance!" do

    describe 'Successfull clearance' do
      let(:wholesale_price) { 100 }
      let(:item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style, wholesale_price: wholesale_price)) }
      before do
        item.clearance!
        item.reload
      end

      it "should mark the item status as clearanced" do
        puts item.errors.full_messages
        expect(item.status).to eq("clearanced")
      end

      it "should set the price_sold as 75% of the wholesale_price" do
        expect(item.price_sold).to eq(BigDecimal.new(wholesale_price) * BigDecimal.new("0.75"))
      end
    end

    describe 'Clearance Validations' do
      describe 'When the clearance price is less than the minimum allowed based on the type' do
        let(:item) { create(:item, style: create(:style, wholesale_price: 4.00, type: 'Dress'))}
        it 'should not allow the clearance sale' do
          expect(item.clearance!).to eq(false)
          item.reload
          expect(item.status).to eq('sellable')
        end
      end
      describe 'When the clearance price is greater than or equal to the minimum allowed' do
        let(:item) { create(:item, style: create(:style, wholesale_price: 100.00, type: 'Dress'))}
        it 'should allow the clearance sale' do
          expect(item.clearance!).to eq(true)
          expect(item.status).to eq('clearanced')
        end
      end
    end

  end
end
