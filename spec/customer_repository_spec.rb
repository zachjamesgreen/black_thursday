require 'spec_helper'

RSpec.describe CustomerRepository do
  let(:customer_repository) { engine.customers }
  describe 'instantiation' do
    it '::new' do
      expect(customer_repository).to be_instance_of(CustomerRepository)
    end
  end

  describe 'customer repository methods' do
    it 'can return an array of all known customer instances'do
      expect(customer_repository.all.size).to eq(1000)
    end

    it 'create customer' do
      customer_1 = customer_repository.create({
                                                :first_name => 'Zach',
                                                :last_name => 'Green',
                                                :created_at => Time.now.to_s,
                                                :updated_at => Time.now.to_s
                                              })
      expected = customer_repository.find_by_id(1001)

      expect(expected.first_name).to eq('Zach')
    end

    it 'find all by customer first name' do
      customer_1 = customer_repository.create({
                                                :first_name => 'Random',
                                                :last_name => 'Green',
                                                :created_at => Time.now.to_s,
                                                :updated_at => Time.now.to_s
                                              })
      customer_2 = customer_repository.create({
                                                :first_name => 'Randomy',
                                                :last_name => 'Brown',
                                                :created_at => Time.now.to_s,
                                                :updated_at => Time.now.to_s
                                              })

      expect(customer_repository.find_all_by_first_name('Rando')).to eq([customer_1, customer_2])
    end

    it 'find all by customer last name' do
      customer_1 = customer_repository.create({
                                                :first_name => 'Zach',
                                                :last_name => 'Random',
                                                :created_at => Time.now.to_s,
                                                :updated_at => Time.now.to_s
                                              })
      customer_2 = customer_repository.create({
                                                :first_name => 'George',
                                                :last_name => 'Randomy',
                                                :created_at => Time.now.to_s,
                                                :updated_at => Time.now.to_s
                                              })

      expect(customer_repository.find_all_by_last_name('Rando')).to eq([customer_1, customer_2])
    end

    it 'can update a customer' do
      customer_1 = customer_repository.create({
                                                :first_name => 'Zach',
                                                :last_name => 'Green',
                                                :created_at => Time.now.to_s,
                                                :updated_at => Time.now.to_s
                                              })

      attributes = { first_name: 'Zachary' }
      expected = customer_repository.update(customer_1.id, attributes)

      expect(expected.first_name).to eq('Zachary')
    end

    it 'can delete a customer' do
      customer_1 = customer_repository.create({
                                                :first_name => 'Zach',
                                                :last_name => 'Green',
                                                :created_at => Time.now.to_s,
                                                :updated_at => Time.now.to_s
                                              })

      expect(customer_repository.delete(customer_1.id)).to eq(customer_1)
      expect(customer_repository.find_by_id(customer_1.id)).to eq(nil)
    end
  end
end
