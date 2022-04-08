require_relative "monteleonemotos/version"
require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_custom/hooks"
require "f1sales_helpers"

module Monteleonemotos
  class Error < StandardError; end
  
  class F1SalesCustom::Hooks::Lead
    def self.switch_source(lead)
      if lead.message.include?('1010433')
        lead.message = "#{lead.source} - Mercês"
      elsif lead.message.include?('1622153')
        lead.message = "#{lead.source} - São Roque"
      elsif lead.message.include?('1629248')
        lead.message = "#{lead.source} - Ibiuna"
      end
      lead
    end
  end
end
