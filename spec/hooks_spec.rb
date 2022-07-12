require 'webmock/rspec'
require 'ostruct'

RSpec.describe F1SalesCustom::Hooks::Lead do
  context 'when needs to change source' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.customer = customer
      lead.message = nil
      lead.description = nil
      lead.product = product

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

    let(:product) do
      product = OpenStruct.new
      product.name = nil

      product
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

    context 'when source is myHonda' do
      let(:source_name) { 'myHonda' }
      before { source.name = source_name }

      context 'when message come with code 1629248' do
        before do
          lead.message = 'Código da concessionária 1629248'
          lead.description = 'Honda Social - Facebook'
        end

        it 'return myHonda - Website Honda - Ibiuna' do
          expect(switch_source).to eq("#{source_name} - Website Honda - Ibiuna")
        end
      end

      context 'when message come with code 1622153' do
        before do
          lead.message = 'Código da concessionária 1622153'
          lead.description = 'Honda Social - Instagram'
        end

        it 'return myHonda - Website Honda - Sroque' do
          expect(switch_source).to eq("#{source_name} - Website Honda - Sroque")
        end
      end

      context 'when message come with message 1010433' do
        before do
          lead.message = 'Código da concessionária 1010433'
          lead.description = 'Website Honda - Site'
        end

        it 'return myHonda Website Concessionária - Mercês' do
          expect(switch_source).to eq("#{source_name} - Website Honda - Mercês")
        end
      end

      context 'when message come with message 1629248' do
        before do
          lead.message = 'Código da concessionária 1629248'
          lead.description = 'Portal do Proprietário'
        end

        it 'return myHonda Website Concessionária - Mercês' do
          expect(switch_source).to eq("#{source_name} - Website Honda - Ibiuna")
        end
      end

      context 'when description come with Website Honda - Site BHB' do
        before do
          lead.message = 'Código da concessionária 1622153'
          lead.description = 'Website Honda - Site BHB'
        end

        it 'return myHonda Website Concessionária - Mercês' do
          expect(switch_source).to eq("#{source_name} - Website Honda - Sroque")
        end
      end

      context 'when product name contains Peças e acessórios' do
        before do
          lead.message = 'Código da concessionária 1010433'
          lead.description = 'WebSite Concessionária - Bot Whatsapp'
          product.name = 'Peças e acessórios'
        end

        it 'return myHonda Website Concessionária - Mercês' do
          expect(switch_source).to eq("#{source_name} - Peças - Mercês")
        end
      end

      context 'when product name contains Peças e acessórios' do
        before do
          lead.message = 'Código da concessionária 1629248'
          lead.description = 'WebSite Concessionária - Bot Whatsapp'
          product.name = 'Agendamento de serviços'
        end

        it 'return myHonda Website Concessionária - Mercês' do
          expect(switch_source).to eq("#{source_name} - Serviços - Ibiuna")
        end
      end
    end
  end
end
