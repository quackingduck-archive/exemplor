# TODO: switch to gem version
require 'lib/exemplor'

Examples do

  def run_example(name, args = nil)
    `ruby -Ilib examples/#{name}.rb#{' ' + args if args}`
  end

  def extract_expected(name)
    File.read("examples/#{name}.rb").split('__END__').last
  end
  
  def expected_and_actual(example_name)
    [run_example(example_name).strip, extract_expected(example_name).strip]
  end
  
  def check_output_matches_expected_for(example_name)
    expected_output, output = expected_and_actual(example_name)
    Check(output).is(expected_output)
  end

end

Examples "Exemplor" do

  eg "errors are caught and nicely displayed" do
    # the output here can't really be checked against the expected as the 
    # backtrace will look slightly different on each platform
    run_example(:an_error)
  end
  
  eg { check_output_matches_expected_for :no_checks }
  eg { check_output_matches_expected_for :oneliner }
  eg { check_output_matches_expected_for :no_checks_non_string }
  eg { check_output_matches_expected_for :with_checks }
  eg { check_output_matches_expected_for :check_with_disambiguation }
  eg { check_output_matches_expected_for :assertion_success }
  eg { check_output_matches_expected_for :assertion_failure }
  eg { check_output_matches_expected_for :assertion_success_and_failure }
  eg { check_output_matches_expected_for :helpers_with_block }
  eg { check_output_matches_expected_for :with_setup }
  
  eg "called with --list arg" do
    list = YAML.load(run_example(:with_setup, '--list'))
    Check(list).is(["Array - modified env", "Array - unmodified env"])
  end
  
  eg "called with --l arg" do
    list = YAML.load(run_example(:with_setup, '--list'))
    Check(list).is(["Array - modified env", "Array - unmodified env"])
  end
  
  eg "called with some other arg (always interpreted as a regex)" do
    run_example(:with_setup, 'unmod')
    tests_run = YAML.load(run_example(:with_setup, 'unmod')).size
    Check(tests_run).is(1)
  end
  
  eg "multiple example groups" do
    list = YAML.load(run_example(:multiple_groups, '--list'))
    Check(list).is(['A - test','B - test','C - test'])
  end
  
end