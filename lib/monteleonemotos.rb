# frozen_string_literal: true

require_relative "monteleonemotos/version"
require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_custom/hooks"
require "f1sales_helpers"

module Monteleonemotos
  class Error < StandardError; end
  # Your code goes here...
  class F1SalesCustom::Hooks::Lead
    def self.switch_source(lead)
      if lead.source == '1010433'
        lead.source = "1010433 - Mercês"
      elsif lead.source == '1622153'
        lead.source = "1622153 - São Roque"
      elsif lead.source = '1629248'
        lead.source = "1629248 - Ibiuna"
      end
      lead
    end
  end
end
