# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pms_asset_pipeline/version'

Gem::Specification.new do |spec|
  spec.name          = "pms_asset_pipeline"
  spec.version       = PmsAssetPipeline::VERSION
  spec.authors       = ["Jean-Baptiste Barth"]
  spec.email         = ["jeanbaptiste.barth@gmail.com"]
  spec.description   = %q{Asset pipeline for PMS}
  spec.summary       = %q{Asset pipeline for PMS}
  spec.homepage      = "https://github.com/jbbarth/redmine_asset_pipeline"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
