require_relative 'lib/member_importer/version'

Gem::Specification.new do |spec|
  spec.name          = "member_importer"
  spec.version       = MemberImporter::VERSION
  spec.authors       = ["Heshie"]
  spec.email         = ["4hbrodygmail.com"]

  spec.summary       = 'Parse csv file and export validated data to csv and a report with the lines that failed.'
  spec.homepage      = 'https://github.com/anihakutin/member_importer'
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = 'https://github.com/anihakutin/member_importer'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
