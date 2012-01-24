Gem::Specification.new do |s|
  s.name      = 'mongoid-auto_increment'
  s.version   = '0.0.0'
  s.platform  = Gem::Platform::RUBY
  s.author    = 'Benjamin Huettinger'
  s.email     = 'benjamin.huettinger@gmail.com'
  s.homepage  = 'https://github.com/maxigs/mongoid-auto_increment'
  s.summary   = 'Extension for Mongoid to have auto-increment fields'

  s.files     = ['lib/mongoid/auto_increment.rb']

  s.add_runtime_dependency('mongoid')
end
