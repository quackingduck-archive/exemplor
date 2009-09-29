require 'rubygems' # TODO: remove
require 'orderedhash'
require 'yaml'

module Exemplor
  
  class Builder
    
    def initialize(examples)
      @examples = examples
    end
    
    def example(name, &body)
      @examples.add_test(name, &body)
    end
    
    def setup(&blk)
      @examples.setup_block = blk
    end
    
    alias_method :eg, :example
    
  end
  
  class Check
    
    attr_reader :expectation, :value
    
    def initialize(name, value)
      @name  = name
      @value = value
    end
    
    def [](disambiguate)
      @disambiguate = disambiguate
    end
    
    def name
      @name + (@disambiguate ? " #{@disambiguate}" : '')
    end
    
    def is(expectation)
      @expectation = expectation
    end
    
    def failure?
      @expectation && @value != @expectation
    end
    
  end
  
  class Example
    
    attr_accessor :_checks
    
    def initialize
      @_checks = []
    end
    
    def Check(value)
      file, line_number = caller.first.match(/^(.+):(\d+)/).captures
      line = File.read(file).map[line_number.to_i - 1]
      name = line[/Check\((.+?)\)/,1]
      check = Check.new(name, value)
      _checks << check
      check
    end
    
  end
  
  class Examples
    
    attr_writer :setup_block
    
    def initialize(name)
      @name = name
      @examples = OrderedHash.new
    end
    
    def add_test(name, &body)
      @examples[name] = body
    end
    
    def run(patterns)
      patterns = Regexp.new(patterns.join('|'))
      @examples.each do |name, body|
        full_name = @name + ' - ' + name
        print_yaml(full_name => run_example(body)) if full_name =~ patterns
      end
    end
    
    def list(patterns)
      patterns = Regexp.new(patterns.join('|'))
      list = @examples.map do |name, body|
        full_name = @name + ' - ' + name
      end.
      select { |full_name| full_name =~ patterns }
      print_yaml list
    end
    
    def print_yaml(obj)
      out = obj.to_yaml.match(/^--- \n/).post_match
      out = colorize out if $stdout.tty?
      print(out)
    end
    
    def colorize(out)
      require 'term/ansicolor'
      out.split("\n").map do |line|
        case line
        when /^  ok/ 
          "#{Term::ANSIColor.reset}#{line}#{Term::ANSIColor.green}"
        when /^  (failure|error)/
          "#{line}#{Term::ANSIColor.reset}#{Term::ANSIColor.red}"
        when /^[^\s]/
          "#{Term::ANSIColor.reset}#{line}"
        else          
          line
        end
      end.join("\n") + "\n#{Term::ANSIColor.reset}"
    end
    
    def run_example(code)
      env = Example.new
      env.instance_eval(&@setup_block) if @setup_block
      begin
        value = env.instance_eval(&code)
        env._checks.empty? ? render_value(value) : render_checks(env._checks)
      rescue Object => error
        render_error(error)
      end      
    end
    
    def render_value(value)
      out = case value
        when String : value
        #when Nil : 'null'
        else ; value.inspect ; end
      { 'ok' => out }
    end
    
    def render_checks(checks)
      failure = nil
      out = OrderedHash.new
      out['ok'] = OrderedHash.new
      checks.each do |check|
         failure = check if check.failure?
         break if failure
         
         out['ok'][check.name] = check.value
      end
      if failure
        out['failure'] = { failure.name => OrderedHash.new }
        out['failure'][failure.name]['expected'] = failure.expectation
        out['failure'][failure.name]['actual'] = failure.value
      end
      out.delete('ok') if out['ok'].empty?
      out
    end
    
    def render_error(error)
      out = OrderedHash.new
      out['class'] = error.class.name
      out['message'] = error.message
      out['backtrace'] = error.backtrace
      { 'error' => out }
    end
    
  end
  
end

def Examples(name = nil, &test_block)
  args = ARGV.dup
  if name.nil? # modify the example environment
    Exemplor::Example.class_eval(&test_block)
  else # define some examples
    examples = Exemplor::Examples.new(name)
    Exemplor::Builder.new(examples).instance_eval(&test_block)
    
    if args.delete('--list') || args.delete('-l')
      examples.list(args)
    else
      examples.run(args)
    end
  end
end