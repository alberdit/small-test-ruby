require_relative 'lib/shortener/version'

Gem::Specification.new do |spec|
  spec.name          = 'shortener'
  spec.version       = Shortener::VERSION
  spec.authors       = ['Alex Recuenco']
  spec.email         = ['alex.recuenco@esave.es']

  spec.summary = 'Just a small test for developers'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
