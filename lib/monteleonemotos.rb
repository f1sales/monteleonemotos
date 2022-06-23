require_relative "monteleonemotos/version"
require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_custom/hooks"
require "f1sales_helpers"

module Monteleonemotos
  class Error < StandardError; end
  class F1SalesCustom::Hooks::Lead
    def self.switch_source(lead)
      source_name = lead.source.name
      lead_message = lead.message ? lead.message : ''
      lead_phone = lead.customer&.phone ? lead.customer.phone.tr('^0-9', '') : ''

      if lead_message.include?('1010433')
        "#{source_name} - Mercês"
      elsif lead_message.include?('1622153')
        "#{source_name} - São Roque"
      elsif lead_message.include?('1629248')
        "#{source_name} - Ibiuna"
      elsif source_name.downcase.include?('mobiauto')
        if lead_phone[0..1] == '11' || lead_phone[0..1] == '15'
          "#{source_name} - DDD"
        else
          "#{source_name} - Descarte"
        end
      else
        source_name
      end
    end
  end
end
