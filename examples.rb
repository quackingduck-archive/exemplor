# uses the gem version, not the one being tested
require 'exemplor'

# slow because each test runs in a subshell

eg.helpers do

  def run_example(name, args = nil)
    `ruby -Ilib examples/#{name}.rb#{' ' + args if args}`
  end

  def extract_expected(name)
    File.read("examples/#{name}.rb").split('__END__').last
  end
  
  def expected_and_actual(example_name)
    [extract_expected(example_name).strip, run_example(example_name).strip]
  end
  
  def check_output_matches_expected_for(example_name)
    expected_output, output = expected_and_actual(example_name)
    Check(output).is(expected_output)
  end

end

eg "version matches file" do
  version = `ruby -Ilib -e "require 'exemplor' ; print Exemplor.version"`
  Check(version).is(File.read(__FILE__.sub('examples.rb','VERSION')))
end

eg "errors are caught and nicely displayed" do
  actual_yaml = YAML.load run_example(:an_error)
  error_hash = actual_yaml[actual_yaml.keys.first]
   # the rest of the bactrace is platform & exemplor version specific
  error_hash['backtrace'] = error_hash['backtrace'][0...1]
  Check(actual_yaml).is(YAML.load(extract_expected(:an_error)))
end

eg { check_output_matches_expected_for :no_checks }
eg { check_output_matches_expected_for :oneliner }
eg { check_output_matches_expected_for :no_checks_non_string }
eg { check_output_matches_expected_for :with_checks }
eg { check_output_matches_expected_for :check_with_disambiguation }
eg { check_output_matches_expected_for :assertion_success }
eg { check_output_matches_expected_for :assertion_failure }
eg { check_output_matches_expected_for :assertion_success_and_failure }
eg { check_output_matches_expected_for :helpers }
eg { check_output_matches_expected_for :with_setup }
eg { check_output_matches_expected_for :checking_nil }
eg { check_output_matches_expected_for :dumping_classes }
eg { check_output_matches_expected_for :check_parsing }

eg "called with --list arg" do
  list = YAML.load(run_example(:with_setup, '--list'))
  Check(list).is(["Modified env", "Unmodified env"])
end

eg "called with --l arg" do
  list = YAML.load(run_example(:with_setup, '--list'))
  Check(list).is(["Modified env", "Unmodified env"])
end

eg "called with some other arg (always interpreted as a regex)" do
  tests_run = YAML.load(run_example(:with_setup, 'Unmodified')).size
  Check(tests_run).is(1)
end