require 'webmock/rspec'
require 'ostruct'

RSpec.describe F1SalesCustom::Hooks::Lead do
  context 'when the message contains code' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.message = 'Código da concessionária 1010433'

      lead
    end

    let(:source_name) { 'Mercado Livre' }

    let(:source) do
      source = OpenStruct.new
      source.name = source_name

      source
    end

    let(:switch_source) { described_class.switch_source(lead) }

    it 'When message is 1010433' do
      expect(switch_source).to eq("#{source_name} - Mercês")
    end

    context 'When message is 1622153' do
      before do
        lead.message = 'Código da concessionária 1622153'
      end

      it 'When message is 1622153' do
        expect(switch_source).to eq("#{source_name} - São Roque")
      end
    end

    context 'When message is 1629248' do
      before do
        lead.message = 'Código da concessionária 1629248'
      end

      it 'When message is 1629248' do
        expect(switch_source).to eq("#{source_name} - Ibiuna")
      end
    end

    context 'When the message does not have the dealership code' do
      before { lead.message = '' }

      it 'When the message does not have the dealership code' do
        expect(switch_source).to eq(source_name)
      end
    end
  end

  context "when needs to change source" do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.customer = customer

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = 'Mobiauto'

      source
    end

    let(:customer) do
      customer = OpenStruct.new
      customer.name = 'Charizard Ash'
      customer.phone = '(11) 91234-1234'
      customer.email = 'charizard@pokemon.com'

      customer
    end

    let(:switch_source) { described_class.switch_source(lead) }

    context 'when is from Mobiauto' do
      it 'phone is from São Paulo' do
        expect(switch_source).to eq('Mobiauto - DDD')
      end

      context 'when phone is from interior of São Paulo' do
        before { customer.phone = '15912342342' }

        it 'return Mobiauto - DDD' do
          expect(switch_source).to eq('Mobiauto - DDD')
        end
      end

      context 'when phone is not from São Paulo or interior of São Paulo' do
        before { customer.phone = '22912341234' }

        it 'return Mobiauto - Descarte' do
          expect(switch_source).to eq('Mobiauto - Descarte')
        end
      end
    end

    context 'when is from Honda Social' do
      before { source.name = 'myHonda - Social - Sroque' }

      it 'return MyHonda' do
        expect(switch_source).to eq('Website Honda')
      end
    end

    context 'when is from Website Honda' do
      before { source.name = '(sem time) Website Honda' }

      it 'return MyHonda' do
        expect(switch_source).to eq('Website Honda')
      end
    end
  end
end
