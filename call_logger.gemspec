
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "call_logger/version"

Gem::Specification.new do |spec|
  spec.name          = "call_logger"
  spec.version       = CallLogger::VERSION
  spec.authors       = ["Maciej Rzasa"]
  spec.email         = ["maciejrzasa@gmail.com"]

  spec.summary       = %q{Debugging tool that logs parameters and results of calling bloks and methods.}
  spec.description   = %q{Decorate a method or wrap a code block to see in logs when they're called.}
  spec.homepage      = "https://github.com/mrzasa/call_logger"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-doc"
end
