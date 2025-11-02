# frozen_string_literal: true

module RubyLspAddonTemplate
  # Hover provides information when users hover over code elements.
  # This example shows a simple message when hovering over class definitions.
  class Hover
    def initialize(response_builder, dispatcher)
      @response_builder = response_builder

      # Register to listen for node events
      # Available node types: class_node, module_node, def_node, call_node, etc.
      # Use _enter suffix for when entering a node, _leave for when leaving
      dispatcher.register(
        self,
        :on_class_node_enter,
        :on_module_node_enter,
        :on_def_node_enter
      )
    end

    # Called when hovering over a class definition
    def on_class_node_enter(node)
      # Get the class name from the constant path
      class_name = node.constant_path.slice

      # Build the hover response with markdown content
      # Categories: :title, :links, :documentation
      @response_builder.push(
        "**Custom Addon Info**\n\n" \
        "This is a class definition for `#{class_name}`.\n\n" \
        "🎉 Hello from Ruby LSP Addon Template!",
        category: :documentation
      )
    end

    # Called when hovering over a module definition
    def on_module_node_enter(node)
      module_name = node.constant_path.slice

      @response_builder.push(
        "**Custom Addon Info**\n\n" \
        "This is a module definition for `#{module_name}`.\n\n" \
        "🎉 Hello from Ruby LSP Addon Template!",
        category: :documentation
      )
    end

    # Called when hovering over a method definition
    def on_def_node_enter(node)
      method_name = node.name

      @response_builder.push(
        "**Custom Addon Info**\n\n" \
        "This is a method definition for `#{method_name}`.\n\n" \
        "🎉 Hello from Ruby LSP Addon Template!",
        category: :documentation
      )
    end
  end
end
