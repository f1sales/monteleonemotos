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
        @source_name = lead.source.name
        source_name_down = @source_name.downcase
        @lead_message = lead.message || ''
        lead_phone = lead.customer&.phone&.tr('^0-9', '') || ''
        @product_name = lead.product&.name&.downcase || ''

        if source_name_down['honda']
          @source_name = unify_sources
          verify_code_message
        elsif source_name_down.include?('mobiauto')
          if lead_phone[0..1] == '11' || lead_phone[0..1] == '15'
            "#{@source_name} - DDD"
          else
            "#{@source_name} - Descarte"
          end
        else
          @source_name
        end
      end

      private

      def unify_sources
        if @product_name['peças']
          "#{@source_name} - Peças"
        elsif @product_name['serviços']
          "#{@source_name} - Serviços"
        else
          "#{@source_name} - Website Honda"
        end
      end

      def verify_code_message
        if @lead_message['1010433']
          "#{@source_name} - Mercês"
        elsif @lead_message['1622153']
          "#{@source_name} - Sroque"
        elsif @lead_message['1629248']
          "#{@source_name} - Ibiuna"
        else
          @source_name
        end
      end
    end
  end
end
