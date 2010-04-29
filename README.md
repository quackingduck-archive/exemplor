Exemplor (the exemplar)
=======================

Introduction
------------

Exemplor is testing framework for high level integration tests that read like example usage scenarios. It's designed with the minimum possible vocabulary, so you can spend more time writing tests and less time learning the testing framework.

The ideal user of exemplor is a developer who is writing their program in small pieces, from the highest level of abstraction they have currently implemented.

For example lets say you were writing a command-line utility to delete all those `.DS_store` files the OS X finder generates when it's going about its business.

The approach the current crop of test frameworks encourage is to write a failing test that calls a method on an instance of a class. For example:

    require 'test_framework'
    require 'my_code'

    context MyMainClass do

      setup do
        # fixture setup
      end

      it "deletes .DS_store files" do
        MyMainClass.new(@fixture_directory).method_that_deletes_files
        assert(not File(@fixture_directory + '/.DS_store').exist?)
        assert(File(@fixture_directory + '/other_file.txt').exist?)
      end

    end

No test framework forces the programmer to start this way. These are just the
kind of examples that come up in the documentation and the open source
projects that make use of the frameworks.

There are a number of issues with this style of testing.

  1.  The test file must reference:

      * The main library file `my_code.rb`
      * The main class `MyMainClass`
      * The primary internal entry point - initialization of MyMainClass with a directory argument and then a call to `method_that_deletes_files` instance method

      If any of these names change, the test must be updated accordingly.

  2.  There is one compulsory level of nesting in the test file. Even if each file only has one context, all tests must be nested under it.

  3.  If the `assert` calls fail, generally the output of the framework is not sufficient enough to determine the exact cause of failure. This is often partially solved with additional methods (or macros) such as `assert_size`, `should_exist` etc. These methods just increase the amount the user must learn to start effectively using the framework.

  4.  The command-line utility - the stated goal of the program - is not yet under test.

The exemplor approach would be something like:

    require 'exemplor'

    def run_inside directory
      system "cd #{directory} && ./path/to/utility"
    end

    eg.setup do
      # fixture setup
    end

    eg "deletes .DS_store files" do
      run_inside @fixture_directory
      Assert(not File(@fixture_directory + '/.DS_store').exist?)
      Assert(File(@fixture_directory + '/other_file.txt').exist?)
    end

This tests the public interface (the command-line interface) of the utility without any information about its internal implementation. All the test knows about is the path to the actual command under test.

This approach to testing allows the developer to write the first implementation without any classes, then refactor to instance methods on a class, then put that class inside a module, then move the library file into a `lib` directory, etc. All while continuing to run the tests that ensure the program works as expected.

Exemplor is not just for command-line utilities. It's for testing the parts of your application that constitute the public interface. In a web app it would be the urls. In a library, it would be the public API. Exemplor can also be used to test your underlying implementation but if you find yourself with a bunch of those tests and nothing that covers the public interface then your doing it wrong.


API Overview
------------

The api is tiny. Here it is

    eg.setup do
      # run before each example, set instance variables here
    end

    eg "an example" do
      # example usage of the thing under test
      Assert(expression_that.should.be(truthy))
      Show(something_to_inspect)
    end

    eg.helpers do
      # helper methods that need to run the context of an example
    end

When run from a terminal, the output optimised for human readability and a high signal-to-noise ratio.

When standard out points to something other than a terminal, the output is information-rich YAML.


Writing Examples
----------------

The simplest possible example:

    eg 'example without Assert() or Show() calls' do
      "foo"
    end

Will just print:

    • example without Assert() or Show() calls: foo

This is useful for "printf driven development" where you just want to check that your code runs and does something useful. To print more than one value per example you can use the `Show()` method:

    eg 'using Show()' do
      list = [1, 2, 3]
      Show(list.last)
      list << 4
      Show(list.first)
      Show(list.last)
    end

prints as:

    ∙ Showing the value of some expression
      • list.first: 1
    ∙ using Show()
      • list.last: 3
      • list.first: 1
      • list.last: 4

`Show()` is like a fancy `Kernel#puts`, you don't need to worry about distinguishing between different calls like you would with normal `puts`:

    puts "last item: #{item.first.to_yaml}"
    puts "last item: #{item.last.to_yaml}"
    # etc.

because `Show()` works out the label from the source code and automatically pretty prints the value as yaml.

Exemplor has only one kind of assertion: `Assert()`. It works like `Show()` in that the label will be read from the source:

    eg 'using Assert()' do
      list = [1, 2, 3]
      Show(list.last)
      Assert(list.last == 3)
    end

prints:

    ∙ using Assert()
      • list.last: 3
      ✓ list.last == 3

If the example contains no `Show()` calls and all the asserts are successful then the entire example is considered successful:

    eg 'using Assert()' do
      list = [1, 2, 3]
      Assert(list.first == 1)
      Assert(list.last == 3)
    end

prints:

    ✓ using Assert()

If an assertion fails then the name of the test is printed with an ✗ next to it:

    eg 'The second Assert() will fail' do
      list = [1, 2, 3]
      Assert(list.first == 1)
      Assert(list.last == 1)
    end

prints:

    ✗ The second Assert() will fail
      ✓ list.first == 1
      ✗ list.last == 1

Nothing fancy, no "expected" and "actual" values are printed, if you want to inspect those you can just add a `Show()` call before the assert.


Running Examples
----------------

Run the example file through ruby

    $> ruby examples.rb

To run only examples that match the regex "location | setting/x"

    $> ruby examples.rb "location | setting/x"

Running with `--list` or `-l` lists all examples:

    $> ruby examples.rb -l
    - errors are caught and nicely displayed
    - check_output_matches_expected_for :no_checks
    - check_output_matches_expected_for :oneliner
    - check_output_matches_expected_for :no_checks_non_string
    - check_output_matches_expected_for :with_checks
    - check_output_matches_expected_for :check_with_disambiguation
    - check_output_matches_expected_for :assertion_success
    - check_output_matches_expected_for :assertion_failure
    - check_output_matches_expected_for :assertion_success_and_failure
    - check_output_matches_expected_for :helpers
    - check_output_matches_expected_for :with_setup
    - called with --list arg
    - called with --l arg
    - called with some other arg (always interpreted as a regex)


Thanks
------

Exemplor was inspired by [testy](http://github.com/ahoward/testy).

What really kicked me over the line to this style of testing and eventually lead to writing exemplor was Yehuda Katz's "Writing Code That Doesn't Suck" presentation at RubyConf 2008. I wasn't there but luckily an excellent video of the presentation is available online[1]. If none of this readme made any sense to you or you have additional questions/concerns I strongly recommend watching that presentation.

[1] http://rubyconf2008.confreaks.com/writing-code-that-doesnt-suck.html