# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "chinese_permalink"
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Huang"]
  s.date = "2011-10-26"
  s.description = "This plugin adds a capability for AR model to create a seo permalink with your chinese text. It will translate your chinese text to english url based on google translate."
  s.email = "flyerhzm@gmail.com"
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    ".autotest",
    "MIT-LICENSE",
    "README.textile",
    "Rakefile",
    "VERSION",
    "chinese_permalink.gemspec",
    "generators/chinese_permalink_migration/chinese_permalink_migration_generator.rb",
    "generators/chinese_permalink_migration/templates/migration.rb",
    "init.rb",
    "lib/chinese_permalink.rb",
    "rails/init.rb",
    "test/chines_permalink_test.rb"
  ]
  s.homepage = "http://github.com/flyerhzm/chinese_permalink"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "This plugin adds a capability for AR model to create a seo permalink with your chinese text."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

