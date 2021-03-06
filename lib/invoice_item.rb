require 'time'

class InvoiceItem
  attr_reader   :id,
                :item_id,
                :invoice_id,
                :created_at
  attr_accessor :updated_at,
                :quantity,
                :unit_price

  def initialize(id:, item_id:, invoice_id:, created_at:, unit_price:, quantity:, updated_at:)
    @id = id.to_i
    @item_id = item_id.to_i
    @invoice_id = invoice_id.to_i
    @created_at = set_time(created_at.to_s)
    @quantity = quantity.to_i
    @unit_price = BigDecimal((unit_price.to_i / 100.to_f), 5)
    @updated_at = set_time(updated_at.to_s)
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end

  def set_time(time)
    if time
      Time.parse(time)
    else
      Time.now
    end
  end
end
