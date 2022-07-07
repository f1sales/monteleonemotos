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
        expect(switch_source).to eq("#{source_name} - Sroque")
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

  context 'when needs to change source' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.customer = customer
      lead.message = nil

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
  end

  context 'when source is myHonda - Website Concessionária' do
    let(:source_name) { 'myHonda - Website Concessionária' }

    context 'without city' do
      before do
        source.name = source_name
      end

      it 'return myHonda Website Concessionária' do
        expect(switch_source).to eq(source_name)
      end
    end

    context 'when come from Sroque' do
      before do
        source.name = "#{source_name} - Sroque"
      end

      it 'return myHonda Website Concessionária - Sroque' do
        expect(switch_source).to eq("#{source_name} - Sroque")
      end
    end

    context 'when come from Ibiuna' do
      before do
        source.name = "#{source_name} - Ibiuna"
      end

      it 'return myHonda Website Concessionária - Ibiuna' do
        expect(switch_source).to eq("#{source_name} - Ibiuna")
      end
    end

    context 'Sroque with message 1622153' do
      before do
        source.name = "#{source_name} - São Roque"
        lead.message = 'Código da concessionária 1622153'
      end

      it 'return myHonda Website Concessionária - Sroque' do
        expect(switch_source).to eq("#{source_name} - Sroque")
      end
    end
  end

  context 'when source name is myHonda - Peças' do
    let(:source_name) { 'myHonda - Peças' }

    context 'when come from Sroque' do
      before do
        source.name = "#{source_name} - Sroque"
      end

      it 'return myHonda - Peças - Sroque' do
        expect(switch_source).to eq("#{source_name} - Sroque")
      end
    end
  end

  context 'when source name is myHonda - Serviços' do
    let(:source_name) { 'myHonda - Serviços' }

    context 'when come from Ibiuna' do
      before do
        source.name = "#{source_name} - Ibiuna"
      end

      it 'return myHonda - Serviços - Ibiuna' do
        expect(switch_source).to eq("#{source_name} - Ibiuna")
      end
    end
  end

  context 'when source name is myHonda - Website Honda' do
    let(:source_name) { 'myHonda - Website Honda' }

    context 'when come from Mercês' do
      before do
        source.name = "#{source_name} - Mercês"
        lead.message = 'Código da concessionária 1010433'
      end

      it 'return myHonda - Website Honda - Mercês' do
        expect(switch_source).to eq("#{source_name} - Mercês")
      end
    end

    context 'when come from São Roque' do
      before do
        source.name = 'Website Honda'
        lead.message = 'Código da concessionária 1622153'
      end

      it 'return myHonda - Website Honda - Sroque' do
        expect(switch_source).to eq(source_name)
      end
    end
  end

  context 'when source name is myHonda - Social' do
    let(:source_name) { 'myHonda - Social' }

    context 'without city' do
      before do
        source.name = source_name
      end

      it 'return myHonda - Social' do
        expect(switch_source).to eq(source_name)
      end
    end

    context 'when come from Mercês' do
      before do
        source.name = "#{source_name} - Mercês"
      end

      it 'return myHonda - Social - Mercês' do
        expect(switch_source).to eq("#{source_name} - Mercês")
      end
    end

    context 'when come only Social in source name' do
      before do
        source.name = 'Social'
      end

      it 'return myHonda - Social' do
        expect(switch_source).to eq(source_name)
      end
    end
  end
end
