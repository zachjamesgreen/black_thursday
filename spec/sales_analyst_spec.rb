require_relative 'spec_helper'

RSpec.describe SalesAnalyst do
  before(:each) do
    @sales_engine = SalesEngine.from_csv({
                            items: './data/items.csv',
                            merchants: './data/merchants.csv',
                         })
  end
  describe 'instantiation' do
    it '::new' do
      sales_analyst = @sales_engine.analyst

      expect(sales_analyst).to be_instance_of(SalesAnalyst)
    end
  end

   describe 'instance methods' do
    it '#average_items_per_merchant' do
     sales_analyst = @sales_engine.analyst

     expect(sales_analyst.average_items_per_merchant).to eq(2.88)
    end

    it '#average_items_per_merchant_standard_deviation' do
     sales_analyst = @sales_engine.analyst
     #come back to make sure it's ok to use 3.16
     expect(sales_analyst.average_items_per_merchant_standard_deviation).to eq(3.16)
    end

    it '#merchants_with_high_item_count' do
     sales_analyst = @sales_engine.analyst

     expect(sales_analyst.merchants_with_high_item_count.size).to eq(49)
    end
    it '#average_item_price_for_merchant' do

      sales_analyst = @sales_engine.analyst
      merchant = @sales_engine.merchants.create({name: "Zachs Store"})
      item_repo = @sales_engine.items
      price = BigDecimal(0)
      item1 = item_repo.create({name: 'item1', description: 'Description1', unit_price: 12345, created_at: Time.now, updated_at: Time.now, merchant_id: merchant.id})
      item2 = item_repo.create({name: 'item2', description: 'Description2', unit_price: 1234, created_at: Time.now, updated_at: Time.now, merchant_id: merchant.id})
      item3 = item_repo.create({name: 'item3', description: 'Description3', unit_price: 1230, created_at: Time.now, updated_at: Time.now, merchant_id: merchant.id})
      item4 = item_repo.create({name: 'item4', description: 'Description4', unit_price: 1200, created_at: Time.now, updated_at: Time.now, merchant_id: merchant.id})
      items_array = [item1,item2,item3,item4]

      items_array.each do |item|
        merchant.add_item(item)
        price += item.unit_price
      end
      average_price = price/4

      expect(sales_analyst.average_item_price_for_merchant(merchant.id)).to eq(average_price)
    end
  end
end
