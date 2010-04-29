task :default => [:test]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gs|
    gs.name     = "exemplor"
    gs.homepage = "http://github.com/quackingduck/exemplor"
    gs.summary  = "A light-weight, low-fi way to provide executable usage examples of your code."
    gs.email    = "myles@myles.id.au"
    gs.authors  = ["Myles Byrne"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Install jeweler to build gem"
end

desc "runs the examples with the rubygems version of exemplor (you must gem install the gem for this to work)"
task :examples, [:filter] do |_,args|
  ruby "-rubygems", "examples.rb", (args.filter || '')
end

desc "runs the examples with the development version (i.e. the one in this dir) of exemplor"
task :dev, [:filter] do |_,args|
  ruby '-rubygems', '-I', 'lib', 'examples.rb', (args.filter || '')
end

task :test => :examples