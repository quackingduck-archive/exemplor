# uses the gem version, not the one being tested
require 'exemplor'

eg "Exemplor.version comes from the version file" do
  version = `ruby -rubygems -Ilib -e "require 'exemplor' ; print Exemplor.version"`
  Check(version).is(File.read(__FILE__.sub('examples.rb','VERSION')))
end

# runs an example file (in /examples) using the development version of exemplor
def run_example(name, args = nil)
  `ruby -rubygems -Ilib examples/#{name}.rb#{' ' + args if args}`
end

# pulls out text after the __END__ in an example file
def expected_output_for name
  File.read("examples/#{name}.rb").split('__END__').last.lstrip + "\n"
end

# a macro that runs an example file and then asserts that the output matches
# the expected output which is specified after the __END__ in that same file
def examples filenames
  filenames.each do |file|
    eg("#{file}.rb") { Check(run_example(file)).is expected_output_for(file) }
  end
end

# slow because each test runs in a subshell
examples %w[
  no_checks
  oneliner
  no_checks_non_string
  with_checks
  check_with_disambiguation
  assertion_success
  assertion_failure
  assertion_success_and_failure
  assertion_success_and_info
  failure_halts_execution
  helpers
  with_setup
  checking_nil
  dumping_classes
  check_parsing
]

eg.helpers do
  # Exemplor outputs valid yaml, for some of our assertions it's easier to use
  # the parsed structure
  def parse_run *args
    YAML.load(run_example(*args))
  end
end

eg "errors are caught and backtraces shown" do
  result = parse_run(:an_error)[0]
  Check(result['status']).is('error')
  Check(result['result']['class']).is('RuntimeError')
  Check(result['result']['message']).is('boom!')
  Check(result['result']['backtrace'][0]).is('examples/an_error.rb:4')
end

eg "exit status is percent of issues that failed or errored" do
  run_example :ten_percent_failures
  Check($?.exitstatus).is(10)
end

eg "--list shows all the example names in the file" do
  Check(parse_run(:foobar, '--list')).is(["foo", "bar"])
end

eg "-l is the same as --list" do
  Check(run_example(:foobar, '-l')).is(run_example(:foobar, '--list'))
end

eg "any other arg is intepreted as a regex and the examples that match it are run" do
  Check(parse_run(:foobar, 'foo').size).is(1)
end