begin
  require 'jeweler'
  Jeweler::Tasks.new do |gs|
    gs.name     = "exemplor"
    gs.homepage = "http://github.com/quackingduck/exemplor"
    gs.summary  = "A light-weight, low-fi way to provide executable usage examples or your code."
    gs.email    = "myles@myles.id.au"
    gs.authors  = ["Myles Byrne"]
    gs.add_dependency('orderedhash', '>= 0.0.6')
    gs.add_dependency('term-ansicolor', '>= 1.0.3')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Install jeweler to build gem"
end

task :examples do
  exec "ruby examples.rb"
end

task :test => :examples