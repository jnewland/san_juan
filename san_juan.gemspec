Gem::Specification.new do |s|
  s.name = %q{san_juan}
  s.version = "0.0.4"
  s.authors = ["Jesse Newland"]
  s.date = %q{2008-05-20}
  s.description = s.summary = %q{Capistrano Recipies for God}
  s.email = %q{jnewland@gmail.com}
  s.homepage = %q{http://github.com/jnewland/san_juan}
  #s.rubyforge_project = %q{san_juan}

  s.files = [
    "lib/san_juan.rb",
    "README.textile"
  ]
  s.require_paths = ["lib"]

  s.add_dependency(%q<capistrano>)

  s.has_rdoc = false
  s.extra_rdoc_files = ["README.textile"]

  s.rubygems_version = %q{1.1.0}
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
end
