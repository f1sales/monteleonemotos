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
      if lead.message.include?('1010433')
        "#{source_name} - Mercês"
      elsif lead.message.include?('1622153')
        "#{source_name} - São Roque"
      elsif lead.message.include?('1629248')
        "#{source_name} - Ibiuna"
      else
        source_name
      end
    end
  end
end
