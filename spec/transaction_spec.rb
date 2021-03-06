require 'spec_helper'

RSpec.describe Transaction do
  describe 'instantiation' do
    describe '::new' do
      it 'exists' do
        transaction = Transaction.new({
                                        :id => 1_234_567,
                                        :invoice_id => 8_901_011,
                                        :credit_card_number => '1234567890123456',
                                        :credit_card_expiration_date => '1221',
                                        :result => :sucess,
                                        :created_at => Time.now.to_s,
                                        :updated_at => Time.now.to_s
                                      })

        expect(transaction).to be_instance_of(Transaction)
      end
    end
  end
end
