# frozen_string_literal: true

require "ruby_lsp/addon"

# Load the hover implementation
require_relative "ruby_lsp_addon_template/hover"

# Load the addon entry point
require_relative "ruby_lsp/ruby_lsp_addon_template/addon"

module RubyLspAddonTemplate
  class Error < StandardError; end

  # Your addon code goes here...
end
