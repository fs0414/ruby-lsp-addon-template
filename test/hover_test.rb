# frozen_string_literal: true

require "test_helper"
require "ruby_lsp/internal"

module RubyLspAddonTemplate
  class HoverTest < Minitest::Test
    def setup
      @uri = URI("file:///fake.rb")
    end

    def test_hover_on_class_definition
      source = <<~RUBY
        class MyClass
          def my_method
            puts "Hello"
          end
        end
      RUBY

      # Parse the source code
      parsed = Prism.parse(source)
      dispatcher = Prism::Dispatcher.new
      response_builder = RubyLsp::ResponseBuilders::Hover.new

      hover = Hover.new(response_builder, dispatcher)

      # Dispatch the parsed tree
      dispatcher.dispatch(parsed.value)

      response = response_builder.response

      # We should have hover information
      refute_nil response
      assert_kind_of String, response

      # Check that the content includes our custom message
      assert_includes response, "Custom Addon Info"
      assert_includes response, "MyClass"
    end

    def test_hover_on_module_definition
      source = <<~RUBY
        module MyModule
          def self.hello
            puts "Hello"
          end
        end
      RUBY

      # Parse the source code
      parsed = Prism.parse(source)
      dispatcher = Prism::Dispatcher.new
      response_builder = RubyLsp::ResponseBuilders::Hover.new

      hover = Hover.new(response_builder, dispatcher)

      # Dispatch the parsed tree
      dispatcher.dispatch(parsed.value)

      response = response_builder.response

      # We should have hover information
      refute_nil response
      assert_kind_of String, response

      # Check that the content includes our custom message
      assert_includes response, "Custom Addon Info"
      assert_includes response, "MyModule"
    end

    def test_hover_on_method_definition
      source = <<~RUBY
        def my_method
          puts "Hello"
        end
      RUBY

      # Parse the source code
      parsed = Prism.parse(source)
      dispatcher = Prism::Dispatcher.new
      response_builder = RubyLsp::ResponseBuilders::Hover.new

      hover = Hover.new(response_builder, dispatcher)

      # Dispatch the parsed tree
      dispatcher.dispatch(parsed.value)

      response = response_builder.response

      # We should have hover information
      refute_nil response
      assert_kind_of String, response

      # Check that the content includes our custom message
      assert_includes response, "Custom Addon Info"
      assert_includes response, "my_method"
    end
  end
end
