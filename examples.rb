require 'exemplor'

# Each test runs in a subshell, exemplor is tested with exemplor but from
# a version running in a different process. Exemplor hates unit tests.

eg "Exemplor.version comes from the version file" do
  version = `ruby -Ilib -e "require 'exemplor' ; print Exemplor.version"`
  version_from_file = File.read(__FILE__.sub('examples.rb','VERSION'))
  Assert(version == version_from_file)
end

# runs an example file (in /examples) using the development version of exemplor
def run_example(name, args = nil)
  `ruby -Ilib examples/#{name}.rb#{' ' + args if args}`
end

# pulls out text after the __END__ in an example file
def expected_output_for name
  File.read("examples/#{name}.rb").split('__END__').last.lstrip + "\n"
end

# a macro that runs an example file and then asserts that the output matches
# the expected output which is specified after the __END__ in that same file
def examples filenames
  filenames.each do |file|
    eg("#{file}.rb") { Assert(run_example(file) == expected_output_for(file)) }
  end
end

examples %w[
  no_checks
  no_checks_non_string

  simple_show
  multi_show
  show_with_disambiguation

  assertion_success
  assertion_failure
  assertion_success_and_failure
  assertion_success_and_info
  failure_halts_execution

  helpers
  with_setup
  checking_nil
  showing_classes
  check_parsing
]

# I never use this guy, candidate for removal
examples %w[oneliner]

eg.helpers do
  # Exemplor outputs valid yaml, for some of our assertions it's easier to use
  # the parsed structure
  def parse_run *args
    YAML.load(run_example(*args))
  end
end

eg "errors are caught and backtraces shown" do
  result = parse_run(:an_error)[0]
  Assert(result['status'] == 'error')
  Assert(result['result']['class'] == 'RuntimeError')
  Assert(result['result']['message'] == 'boom!')
  Assert(result['result']['backtrace'][0] == 'examples/an_error.rb:4')
end

eg "exit status is percent of issues that failed or errored" do
  run_example :ten_percent_failures
  Assert($?.exitstatus == 10)
end

eg "--list shows all the example names in the file" do
  Assert(parse_run(:foobar, '--list') == ["foo", "bar"])
end

eg "-l is the same as --list" do
  Assert(run_example(:foobar, '-l') == run_example(:foobar, '--list'))
end

eg "any other arg is intepreted as a regex and the examples that match it are run" do
  Assert(parse_run(:foobar, 'foo').size == 1)
end