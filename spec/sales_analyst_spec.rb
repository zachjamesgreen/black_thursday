require_relative 'spec_helper'

RSpec.describe SalesAnalyst do
  before(:each) do
    @sales_engine = SalesEngine.from_csv({

                            items: './data/items.csv',
                            merchants: './data/merchants.csv',
                            invoices: './data/invoices.csv',
                            invoice_items: './data/invoice_items.csv',
                            transactions: './data/transactions.csv',
                            customers: './data/customers.csv',
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
      # come back to make sure it's ok to use 3.16
      expect(sales_analyst.average_items_per_merchant_standard_deviation).to eq(3.26)
    end

    it '#merchants_with_high_item_count' do
      sales_analyst = @sales_engine.analyst

      expect(sales_analyst.merchants_with_high_item_count.size).to eq(52)
    end

    it '#average_item_price_for_merchant' do
      sales_analyst = @sales_engine.analyst
      merchant = @sales_engine.merchants.create({ name: 'Zachs Store' })
      item_repo = @sales_engine.items
      price = BigDecimal(0)
      item1 = item_repo.create({ name: 'item1', description: 'Description1', unit_price: 12_345, created_at: Time.now,
                                 updated_at: Time.now, merchant_id: merchant.id })
      item2 = item_repo.create({ name: 'item2', description: 'Description2', unit_price: 1234, created_at: Time.now,
                                 updated_at: Time.now, merchant_id: merchant.id })
      item3 = item_repo.create({ name: 'item3', description: 'Description3', unit_price: 1230, created_at: Time.now,
                                 updated_at: Time.now, merchant_id: merchant.id })
      item4 = item_repo.create({ name: 'item4', description: 'Description4', unit_price: 1200, created_at: Time.now,
                                 updated_at: Time.now, merchant_id: merchant.id })
      items_array = [item1, item2, item3, item4]

      items_array.each do |item|
        merchant.add_item(item)
        price += item.unit_price
      end
      average_price = BigDecimal(price / 4, 5)

      expect(sales_analyst.average_item_price_for_merchant(merchant.id)).to eq(average_price.round(2))
    end

    it '#average_average_price_per_merchant' do
      sales_analyst = @sales_engine.analyst
      item_repo = @sales_engine.items
      @sales_engine.merchants.all.clear
      merchant1 = @sales_engine.merchants.create({ name: 'Zach Shop1' })
      merchant2 = @sales_engine.merchants.create({ name: 'Zach Shop2' })
      merchant3 = @sales_engine.merchants.create({ name: 'Zach Shop3' })
      merchants = [merchant1, merchant2, merchant3]

      prices = {
        merchant1 => [],
        merchant2 => [],
        merchant3 => []
      }

      merchants.each do |merchant|
        4.times do |i|
          item = item_repo.create({ name: "item#{i}", description: "Description#{i}", unit_price: rand(100..99_999),
                                    created_at: Time.now, updated_at: Time.now, merchant_id: merchant.id })
          merchant.add_item(item)
          prices[merchant] << item.unit_price
        end
      end

      average_prices = prices.each do |k, v|
        prices[k] = v.sum / v.size
      end

      average = []
      average_prices.each do |_, v|
        average << v
      end

      average = BigDecimal((average.sum / average.size), 5).round(2)

      expect(sales_analyst.average_average_price_per_merchant).to eq(average)
    end

    it '#golden_items' do
      sales_analyst = @sales_engine.analyst

      expect(sales_analyst.golden_items.size).to eq(5)
    end
  end

  describe 'business intelligence on invoices' do
    it '#average_invoices_per_merchant' do
      sales_analyst = @sales_engine.analyst

      expect(sales_analyst.average_invoices_per_merchant).to eq(10.49)
    end

    it '#average_invoices_per_merchant_standard_deviation' do
      sales_analyst = @sales_engine.analyst
      # come back to make sure it's ok to use 3.16
      expect(sales_analyst.average_invoices_per_merchant_standard_deviation).to eq(3.29)
    end

    it '#top_merchants_by_invoice_count' do
      sales_analyst = @sales_engine.analyst

      expect(sales_analyst.top_merchants_by_invoice_count.size).to eq(12)
    end

    it '#bottom_merchants_by_invoice_count' do
      sales_analyst = @sales_engine.analyst

      expect(sales_analyst.bottom_merchants_by_invoice_count.size).to eq(4)
    end

    it '#top_days_by_invoice_count' do
      sales_analyst = @sales_engine.analyst

      expect(sales_analyst.top_days_by_invoice_count).to eq(['Wednesday'])
    end

    it '#invoice_status' do
      sales_analyst = @sales_engine.analyst

      expect(sales_analyst.invoice_status(:pending)).to eq(29.55)
      expect(sales_analyst.invoice_status(:shipped)).to eq(56.95)
      expect(sales_analyst.invoice_status(:returned)).to eq(13.5)
    end
  end
end
