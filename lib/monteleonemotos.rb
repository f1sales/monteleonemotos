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
      if lead.message == '1010433'
        lead.product.name = 'Mercês'
      elsif lead.message == '1622153'
        lead.product.name = 'São Roque'
      elsif lead.product.name = '1629248'
        lead.product.name = 'Ibiuna'
      end
      lead
    end
  end
end
