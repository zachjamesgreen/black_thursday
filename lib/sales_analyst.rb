class SalesAnalyst
  def initialize(engine)
    @engine = engine
  end

  def items_per_merchant
    merchants = @engine.merchants
    items = @engine.items

    merchants.all.map do |merchant|
      items.find_all_by_merchant_id(merchant.id).size
    end
  end

  def average_items_per_merchant
    ipm = items_per_merchant
    (ipm.sum / ipm.size.to_f).round(2)
  end

  def average_items_per_merchant_standard_deviation
    ipm = items_per_merchant
    standard_deviation(ipm)
  end

  def merchants_with_high_item_count
    merchants = @engine.merchants.all.sort { |a, b| b.items.size <=> a.items.size }
    cut_off = (merchants.size * 0.5).round
    short_list = merchants[0..cut_off]
    # average = average_items_per_merchant
    # merchants_filtered = @engine.merchants.all.select do |merchant|
    #   merchant.items.size > average
    # end

    w = short_list.find_all do |merchant|
      # require "pry"; binding.pry
      merchant.items.size > (average_items_per_merchant + average_items_per_merchant_standard_deviation)
    end
    # require "pry"; binding.pry
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = @engine.merchants.find_by_id(merchant_id)
    prices = merchant.items.map { |item| item.unit_price }
    BigDecimal(prices.sum / prices.size, 5).round(2)
  end

  def average_average_price_per_merchant
    merchants = @engine.merchants.all
    total_average = []
    merchants.each do |merchant|
      total_average << average_item_price_for_merchant(merchant.id)
    end
    BigDecimal(total_average.sum / merchants.size, 5).round(2)
  end
  #     item_prices = []
  #     merchant.items.each do |item|
  #       item_prices << item.unit_price
  #     end
  #     total_average << item_prices.sum / item_prices.size
  #   end
  #   BigDecimal((total_average.sum / total_average.size), 5).round(2)
  # end

  # any item that is two standard deviations above the standard
  def golden_items
    item_price = @engine.items.all.map do |item|
      item.unit_price
    end
    golden = average(item_price) + (standard_deviation(item_price) * 2)
      @engine.items.all.find_all do |item|
        item.unit_price > golden
      end
  end

  def average(array)
    array.sum / array.size
  end
  # helper method for average_items_per_merchant_standard_deviation
  # an array
  def standard_deviation(sample_size)
    total_number_of_elements = sample_size.size
    mean = sample_size.sum / sample_size.size.to_r
    new_sample_size = sample_size.map do |ss|
      (ss - mean)**2
    end
    s = new_sample_size.sum / (total_number_of_elements - 1)
    Math.sqrt(s).round(2)
  end

 # gives you the invoice object
  def invoices_per_merchant
    merchants = @engine.merchants
    invoices = @engine.invoices

    merchants.all.map do |merchant|
      invoices.find_all_by_merchant_id(merchant.id).size
    end
  end

  def invoices_count_per_merchant
    invoices_per_merchant.size
  end

  def average_invoices_per_merchant
    (invoices_per_merchant.sum / invoices_per_merchant.size.to_f).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviation(invoices_per_merchant)
  end

  def top_merchants_by_invoice_count
    # iterate over merchants to see how many invoices they have
    # if that number is higher than the average + 2 st. dev.
    # return that value
    invoices = @engine.invoices
    golden_invoices = average_invoices_per_merchant + (average_invoices_per_merchant_standard_deviation * 2)
    @engine.merchants.all.find_all do |merchant|
      invoices.find_all_by_merchant_id(merchant.id).size > golden_invoices
    end
  end

  def bottom_merchants_by_invoice_count
    invoices = @engine.invoices
    golden_invoices = average_invoices_per_merchant - (average_invoices_per_merchant_standard_deviation * 2)
    @engine.merchants.all.find_all do |merchant|
      invoices.find_all_by_merchant_id(merchant.id).size < golden_invoices
    end
  end

  def top_days_by_invoice_count
    # days with highest number of sales by invoice count
    invoice_repo = @engine.invoices
    average_per_day = invoice_repo.all.size / 7
    grouped_invoices = Hash.new{|h,k| h[k] = 0}
    invoice_repo.all.each do |invoice|
       case invoice.created_at.wday
       when 0
         grouped_invoices['Sunday'] += 1
       when 1
         grouped_invoices['Monday'] += 1
       when 2
         grouped_invoices['Tuesday'] += 1
       when 3
         grouped_invoices['Wednesday'] += 1
       when 4
         grouped_invoices['Thursday'] += 1
       when 5
         grouped_invoices['Friday'] += 1
       when 6
         grouped_invoices['Saturday'] += 1
       end
    end
     golden = average_per_day + standard_deviation(grouped_invoices.values)
    grouped_invoices.find_all do |wday, invoice_count|
      if invoice_count < golden
        grouped_invoices.delete(wday)
      end
    end
    grouped_invoices.keys
  end

  def invoice_status(status)
    invoices = @engine.invoices
    ((invoices.find_all_by_status(status).size / invoices.all.size.to_f) * 100).round(2)
  end

end
