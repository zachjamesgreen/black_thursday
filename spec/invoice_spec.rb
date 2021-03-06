require 'spec_helper'

RSpec.describe Invoice do
  describe 'instantiation' do
    describe '::new' do
      it 'exists' do
        invoice = Invoice.new({
                                :id => 1_234_567,
                                :customer_id => 89_101_112,
                                :merchant_id => 13_141_516,
                                :created_at => Time.now.to_s,
                                :status => 'pending',
                                :updated_at => Time.now.to_s
                              })

        expect(invoice).to be_instance_of(Invoice)
      end
    end
  end
end
