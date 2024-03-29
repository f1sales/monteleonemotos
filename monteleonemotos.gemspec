# frozen_string_literal: true

require_relative 'lib/monteleonemotos/version'

Gem::Specification.new do |spec|
  spec.name         = 'monteleonemotos'
  spec.version      = Monteleonemotos::VERSION
  spec.authors      = ['Nathanael Vieira']
  spec.email        = ['nathanael@f1sales.com.br']

  spec.summary      = 'Write a short summary, because RubyGems requires one.'
  spec.description  = 'Write a longer description or delete this line.'
  spec.homepage     = 'https://f1sales.com.br'
  # spec.required_ruby_version = ">= 2.6.0"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to your gem server 'https://example.com'"

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/f1sales/monteleonemotos'
    spec.metadata['changelog_uri'] = 'https://github.com/f1sales/monteleonemotos'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir         = 'exe'
  spec.executables    = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths  = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
