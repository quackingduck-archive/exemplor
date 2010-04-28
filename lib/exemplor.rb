# -- Implementation

require 'yaml'

module Exemplor

  extend self

  def path(rel_path)
    File.join(File.dirname(__FILE__), rel_path)
  end

  def version
    File.read(path('/../VERSION'))
  end

end

require Exemplor.path('/../vendor/orderedhash-0.0.6/lib/orderedhash')

require Exemplor.path('/ext')
require Exemplor.path('/checker')
require Exemplor.path('/result_printer')
require Exemplor.path('/environment')
require Exemplor.path('/examples')
require Exemplor.path('/command')

# -- Public API

# Interface for defining examples and configuring their environment.
#
# To define an example call eg with a name and block
#
#   eg "yellling" do
#     "hi".capitalize
#   end
#
# `eg` can be called without a name if the entire call is on one line, in
# that case the code in the example is used as its name:
#
#   eg { the_duck_swims_in_the_pond }
#   same as:
#   eg("the_duck_swims_in_the_pond") { the_duck_swims_in_the_pond }
#
# Call `eg` without args to configure the examples enviornment:
#
#   eg.setup do
#     # code here will run before each example
#   end
#
#   eg.helpers do
#     # methods defined here can be called from inside an example
#   end
#
def eg(name = nil, &example)
  called_without_args = name.nil? && example.nil?
  return Exemplor.environment if called_without_args

  Exemplor.set_example_file_from caller unless Exemplor.example_file_set?

  called_without_explicit_name = name.nil? && !example.nil?
  name = Exemplor.make_example_name_from caller if called_without_explicit_name

  Exemplor.examples.add(name, &example)
end

# Command line interface
at_exit { Exemplor(ARGV) if Exemplor.run_directly? }