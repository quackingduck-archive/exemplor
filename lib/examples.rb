module Exemplor

  def examples
    @examples ||= Examples.new
  end

  # sets @example_file to first file that calls the `eg` method
  def set_example_file_from(caller_trace)
    @example_file ||= caller_trace.first.split(":").first
  end

  def example_file_set?
    !!@example_file
  end

  def run_directly?
    @example_file == $0
  end

  class ExampleDefinitionError < StandardError ; end

  def make_example_name_from(caller_trace)
    file, line_number = caller_trace.first.match(/^(.+):(\d+)/).captures
    line = File.readlines(file)[line_number.to_i - 1].strip
    name = line[/^eg\s*\{\s*(.+?)\s*\}$/,1]
    raise Exemplor::ExampleDefinitionError, "example at #{caller_trace.first} has no name so must be on one line" if name.nil?
    name
  end

  class Examples

    def initialize
      # TODO: no OrderedHash here
      @examples = OrderedHash.new
    end

    def add(name, &body)
      @examples[name] = body
    end

    def run(patterns)
      fails = 0
      # unoffically supports multiple patterns
      patterns = Regexp.new(patterns.join('|'))
      examples_to_run = @examples.select { |name,_| name =~ patterns }
      return 0 if examples_to_run.empty?
      examples_to_run.each do |name, code|
        result = ResultPrinter.new(name, *Environment.run(&code))
        fails +=1 if result.failure?
        puts($stdout.tty? ? result.fancy : result.yaml)
      end
      (fails.to_f/examples_to_run.size)*100
    end

    def list(patterns)
      patterns = Regexp.new(patterns.join('|'))
      list = @examples.keys.select { |name| name =~ patterns }
      print YAML.without_header(list)
    end

  end

end