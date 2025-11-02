# frozen_string_literal: true

require "test_helper"

module RubyLsp
  module RubyLspAddonTemplate
    class AddonTest < Minitest::Test
      def setup
        @addon = Addon.new
      end

      def test_addon_name
        assert_equal "Ruby LSP Addon Template", @addon.name
      end

      def test_addon_version
        assert_equal "0.1.0", @addon.version
      end

      def test_addon_activate
        # Test that activation doesn't raise errors
        assert_silent do
          # Suppress the warning message
          original_stderr = $stderr
          $stderr = StringIO.new
          begin
            @addon.activate(nil, nil)
          ensure
            $stderr = original_stderr
          end
        end
      end

      def test_addon_deactivate
        # Test that deactivation doesn't raise errors
        assert_silent { @addon.deactivate }
      end

      def test_create_hover_listener
        dispatcher = Prism::Dispatcher.new
        response_builder = RubyLsp::ResponseBuilders::Hover.new
        node_context = nil # Not used in our simple implementation

        listener = @addon.create_hover_listener(response_builder, node_context, dispatcher)

        assert_instance_of ::RubyLspAddonTemplate::Hover, listener
      end
    end
  end
end
