require 'webmock/rspec'
require 'ostruct'

RSpec.describe F1SalesCustom::Hooks::Lead do
  let(:lead) do
    lead = OpenStruct.new
    lead.source = source
    lead.message = 'Código da concessionária 1010433'

    lead
  end

  let(:source) do
    source = OpenStruct.new
    source.name = 'myHonda - Website Concessionária'

    source
  end

  let(:switch_source) { described_class.switch_source(lead) }

  it 'When message is 1010433' do
    expect(switch_source).to eq('myHonda - Website Concessionária - Mercês')
  end

  context 'When message is 1622153' do 
    before do
      lead.message = 'Código da concessionária 1622153'
    end

    it 'When message is 1622153' do
      expect(switch_source).to eq('myHonda - Website Concessionária - São Roque')
    end
  end

  context 'When message is 1629248' do 
    before do
      lead.message = 'Código da concessionária 1629248'
    end

    it 'When message is 1629248' do
      expect(switch_source).to eq('myHonda - Website Concessionária - Ibiuna')
    end
  end

  context 'When the message does not have the dealership code' do
    before { lead.message = '' }

    it 'When the message does not have the dealership code' do
      expect(switch_source).to eq('myHonda - Website Concessionária')
    end
  end
end
