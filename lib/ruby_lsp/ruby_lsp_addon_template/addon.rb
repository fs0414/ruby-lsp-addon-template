# frozen_string_literal: true

require "ruby_lsp/addon"
require_relative "../../ruby_lsp_addon_template/hover"

module RubyLsp
  module RubyLspAddonTemplate
    # This class is the entry point for the addon. It must be placed in
    # lib/ruby_lsp/[gem_name]/addon.rb to be automatically detected by Ruby LSP.
    class Addon < ::RubyLsp::Addon
      # The addon name
      def name
        "Ruby LSP Addon Template"
      end

      # The addon version (required for compatibility checks)
      def version
        "0.1.0"
      end

      # Called when the addon is activated
      def activate(global_state, message_queue)
        # You can initialize any necessary state here
        # global_state: contains information about the workspace
        # message_queue: used to send notifications to the client

        warn "Ruby LSP Addon Template activated!"
      end

      # Called when the addon is deactivated
      def deactivate
        # Clean up any resources here
      end

      # Creates a new Hover listener. This method is invoked on every Hover request
      # @param response_builder [ResponseBuilders::Hover] The response builder for hover
      # @param node_context [NodeContext] Context information about the current node
      # @param dispatcher [Prism::Dispatcher] The dispatcher to register listeners with
      def create_hover_listener(response_builder, node_context, dispatcher)
        ::RubyLspAddonTemplate::Hover.new(response_builder, dispatcher)
      end
    end
  end
end
