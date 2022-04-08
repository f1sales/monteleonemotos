require 'webmock/rspec'
require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Hooks::Lead do
  let(:lead) do
    lead = OpenStruct.new
    lead.source = source
    lead.customer = customer
    lead.message = 'Código da concessionária 1010433'

    lead
  end

  let(:customer) do
    customer = OpenStruct.new
    customer.name = 'Raphael'
    customer.phone = '11989114444'
    customer.email = 'nathanael@f1sales.com.br'

    customer
  end

  let(:source) do
    source = OpenStruct.new
    source.name = 'myHonda - Website Concessionária'
  end

  let(:switch_source) { described_class.switch_source(lead) }


  it 'When message is 1010433' do
    expect(switch_source.message).to eq('myHonda - Website Concessionária - Mercês')
  end

  context 'When message is 1622153' do 
    before do
      lead.message = 'Código da concessionária 1622153'
    end

    it 'When message is 1622153' do
      expect(switch_source.message).to eq('myHonda - Website Concessionária - São Roque')
    end
  end

  context 'When message is 1629248' do 
    before do
      lead.message = 'Código da concessionária 1629248'
    end

    it 'When message is 1629248' do
      expect(switch_source.message).to eq('myHonda - Website Concessionária - Ibiuna')
    end
  end
end
