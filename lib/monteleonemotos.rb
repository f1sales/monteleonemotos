require_relative 'monteleonemotos/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'
require 'f1sales_helpers'

module Monteleonemotos
  class Error < StandardError; end

  class F1SalesCustom::Hooks::Lead
    class << self
      def switch_source(lead)
        @lead = lead
        @source_name = @lead.source.name
        if source_name_down['honda']
          return nil if @lead.attachments

          return 'Fonte sem time' if description_down['offline']

          honda_source
        elsif source_name_down.include?('mobiauto')
          mobiauto_source
        else
          @source_name
        end
      end

      private

      def description_down
        @lead.description&.downcase || ''
      end

      def source_name_down
        @source_name.downcase
      end

      def lead_phone
        @lead.customer&.phone&.tr('^0-9', '') || ''
      end

      def lead_message
        @lead.message || ''
      end

      def product_name
        @lead.product&.name&.downcase || ''
      end

      def honda_source
        @source_name = unify_sources
        verify_code_message
      end

      def mobiauto_source
        if lead_phone[0..1] == '11' || lead_phone[0..1] == '15'
          "#{@source_name} - DDD"
        else
          "#{@source_name} - Descarte"
        end
      end

      def unify_sources
        if product_name['peças']
          "#{@source_name} - Peças"
        elsif product_name['serviços']
          "#{@source_name} - Serviços"
        elsif @source_name['Website Honda']
          @source_name
        else
          "#{@source_name} - Website Honda"
        end
      end

      def verify_code_message
        if lead_message['1010433']
          "#{@source_name} - Mercês"
        elsif lead_message['1622153']
          "#{@source_name} - Sroque"
        elsif lead_message['1629248']
          "#{@source_name} - Ibiuna"
        else
          @source_name
        end
      end
    end
  end
end
