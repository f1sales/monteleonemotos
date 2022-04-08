require 'webmock/rspec'
require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Hooks::Lead do
  let(:lead) do
    lead = OpenStruct.new
    lead.source = source
    #lead.product = product
    lead.customer = customer
    lead.message = '1010433'

    lead
  end

  let(:customer) do
    customer = OpenStruct.new
    customer.name = 'Raphael'
    customer.phone = '11989114444'
    customer.email = 'nathanael@f1sales.com.br'

    customer
  end

  #let(:product) do
  #  product = OpenStruct.new
  #  product.name = ''
#
  #  product
  #end

  let(:source) do
    source = OpenStruct.new
    source.name = '1010433'
  end

  let(:switch_source) { described_class.switch_source(lead) }


  it 'When message is 1010433' do
    expect(switch_source.source).to eq('1010433 - Mercês')
  end

  context 'When message is 1622153' do 
    before do
      lead.source = '1622153'
    end

    it 'When message is 1622153' do
      expect(switch_source.source).to eq('1622153 - São Roque')
    end
  end

  context 'When message is 1629248' do 
    before do
      lead.source = '1629248'
    end

    it 'When message is 1629248' do
      expect(switch_source.source).to eq('1629248 - Ibiuna')
    end
  end
end
