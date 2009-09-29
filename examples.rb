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
  
  def check_output(example_name)
    expected_output, output = expected_and_actual(example_name)
    Check(output).is(expected_output)
  end

end

Examples "Exemplor" do
  
  eg "return value of block printed if no checks are present" do
    check_output :no_checks
  end
  
  eg "no checks, non-string returned" do
    check_output :no_checks_non_string
  end
  
  eg "errors are caught and nicely displayed" do
    # the output here can't really be checked against the expected as the 
    # backtrace will look slightly different on each platform
    run_example(:an_error)
  end
  
  eg "the Check() method prints the value of its argument" do
    check_output :with_checks
  end
  
  eg "second argument to call disambiguates" do
    check_output :check_with_disambiguation
  end
  
  eg "assertion style check with Check().is() - success" do
    check_output :assertion_success
  end
  
  eg "assertion style check with Check().is() - failure" do
    check_output :assertion_failure
  end
  
  eg "two successful assertions followed by a failure" do
    check_output :assertion_success_and_failure
  end
  
  eg "helpers - block" do
    check_output :helpers_with_block
  end
  
  eg "with setup block" do
    check_output :with_setup
  end
  
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