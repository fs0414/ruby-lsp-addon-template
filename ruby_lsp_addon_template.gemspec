# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "ruby_lsp_addon_template"
  spec.version = "0.1.0"
  spec.authors = ["Your Name"]
  spec.email = ["your.email@example.com"]

  spec.summary = "A template for creating Ruby LSP addons"
  spec.description = "This gem demonstrates how to create a custom addon for the Ruby LSP, providing hover information for Ruby code."
  spec.homepage = "https://github.com/yourusername/ruby-lsp-addon-template"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yourusername/ruby-lsp-addon-template"
  spec.metadata["changelog_uri"] = "https://github.com/yourusername/ruby-lsp-addon-template/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob("lib/**/*.rb") + ["README.md", "LICENSE.txt"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Ruby LSP dependency
  spec.add_dependency "ruby-lsp", "~> 0.22"

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.50"
end
