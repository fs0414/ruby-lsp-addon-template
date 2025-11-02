# Ruby LSP Addon Template

A template and reference implementation for creating custom addons for the [Ruby LSP](https://github.com/Shopify/ruby-lsp).

## Overview

This gem demonstrates how to create a custom addon for the Ruby LSP. It provides a working example of:

- ✅ Hover information for classes, modules, and methods
- ✅ Proper addon structure and file organization
- ✅ Integration with Ruby LSP's listener system
- ✅ Test coverage using Minitest

## Installation

Add this gem to your application's Gemfile:

```ruby
gem "ruby_lsp_addon_template"
```

Or install it globally:

```bash
gem install ruby_lsp_addon_template
```

## Usage

Once installed, the addon will be automatically detected and activated by Ruby LSP. When you hover over:

- **Class definitions**: See custom hover info with the class name
- **Module definitions**: See custom hover info with the module name
- **Method definitions**: See custom hover info with the method name

### Example

```ruby
class MyClass  # Hover here to see: "This is a class definition for MyClass"
  def my_method  # Hover here to see: "This is a method definition for my_method"
    puts "Hello, world!"
  end
end
```

## Development

After checking out the repo, run `bundle install` to install dependencies.

### Running Tests

```bash
bundle exec rake test
```

### Project Structure

```
lib/
├── ruby_lsp_addon_template.rb              # Main entry point
├── ruby_lsp/
│   └── ruby_lsp_addon_template/
│       └── addon.rb                         # Addon registration (must be here!)
└── ruby_lsp_addon_template/
    └── hover.rb                             # Hover request handler

test/
├── test_helper.rb
├── addon_test.rb
└── hover_test.rb
```

### Key Files

1. **`lib/ruby_lsp/ruby_lsp_addon_template/addon.rb`** - The addon entry point. Must be located at `lib/ruby_lsp/[gem_name]/addon.rb` for automatic detection.

2. **`lib/ruby_lsp_addon_template/hover.rb`** - Implements hover functionality using the Listener pattern.

3. **`ruby_lsp_addon_template.gemspec`** - Gem specification with ruby-lsp dependency.

## Creating Your Own Addon

Use this template as a starting point:

### 1. Clone and Rename

```bash
git clone https://github.com/yourusername/ruby-lsp-addon-template
cd ruby-lsp-addon-template
# Rename files and directories to match your addon name
```

### 2. Update Key Files

- `*.gemspec` - Change name, description, and metadata
- `lib/ruby_lsp/[your_gem_name]/addon.rb` - Update module and class names
- `lib/[your_gem_name]/hover.rb` - Customize hover logic

### 3. Implement Features

Add more listeners for other LSP features:

```ruby
def create_listener(listener_class, uri, dispatcher)
  case listener_class
  when "textDocument/hover"
    YourAddon::Hover.new(uri, dispatcher)
  when "textDocument/definition"
    YourAddon::Definition.new(uri, dispatcher)
  when "textDocument/completion"
    YourAddon::Completion.new(uri, dispatcher)
  end
end
```

### Available Node Types

You can listen for various Ruby syntax nodes:

- `:on_class` - Class definitions
- `:on_module` - Module definitions
- `:on_def_node` - Method definitions
- `:on_call` - Method calls
- `:on_const` - Constants
- And many more...

See [Prism documentation](https://github.com/ruby/prism) for all available node types.

## How It Works

1. **Auto-detection**: Ruby LSP automatically discovers addons by looking for `lib/ruby_lsp/*/addon.rb` files.

2. **Registration**: Your `Addon` class inherits from `RubyLsp::Addon` and implements:
   - `name` - Addon identifier
   - `activate` - Initialize when LSP starts
   - `create_listener` - Create request handlers

3. **Listeners**: Implement `RubyLsp::Listener` to handle specific LSP requests:
   - Register for syntax node events via dispatcher
   - Build responses using ResponseBuilders
   - Return the response

## Resources

- [Ruby LSP Documentation](https://shopify.github.io/ruby-lsp/)
- [Ruby LSP Addon Guide](https://shopify.github.io/ruby-lsp/RubyLsp/Addon.html)
- [LSP Specification](https://microsoft.github.io/language-server-protocol/)
- [Prism Parser](https://github.com/ruby/prism)

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
