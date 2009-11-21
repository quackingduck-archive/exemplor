require 'orderedhash'
require 'yaml'

def OrderedHash(&blk)
  ohsh = OrderedHash.new
  blk.call(ohsh)
  ohsh
end

def YAML.without_header(obj)
  obj.to_yaml.match(/^--- \n?/).post_match
end

class String
  def indent
    self.split("\n").map { |line| '  ' + line }.join("\n")
  end
end

module Exemplor
  
  def self.version() File.read(__FILE__.sub('lib/exemplor.rb','VERSION')) end
  
  class ExampleDefinitionError < StandardError ; end
  
  class Check
    
    attr_reader :expectation, :value
    
    def initialize(name, value)
      @name  = name
      @value = value
    end
    
    def [](disambiguate)
      @disambiguate = disambiguate
      self
    end
    
    def name
      @name + (defined?(@disambiguate) ? " #{@disambiguate}" : '')
    end
    
    def is(expectation)
      @expectation = expectation
    end
    
    def status
      return :info unless defined? @expectation
      @value == @expectation ? :success : :failure
    end
    
    def success?
      status == :success
    end
    
    def failure?
      status == :failure
    end
    
    def info?
      status == :info
    end
    
  end
  
  class ResultPrinter
    
    attr_reader :name,:status,:result,:stderr
    
    def initialize(name,status,result,stderr)
      @name,@status,@result,@stderr = name,status,result,stderr
    end
    
    def failure?
      [:error,:failure].include?(self.status)
    end
    
    def yaml
      hsh = OrderedHash do |o|
        o['name'] = self.name
        o['status'] = case status = self.status
          when :info  : 'info (no checks)'
          when :infos : 'info (with checks)'
          else ; status.to_s
        end
        o['result'] = self.result
      end
      YAML.without_header([hsh])# prints an array
    end
    
    def fancy
      # •∙ are inverted in my terminal font (Incosolata) so I'm swapping them
      require 'term/ansicolor'
      case status
      when :info : blue format_info("• #{name}", result)
      when :infos
        formatted_result = result.map do |r|
          format_info("• #{r['name']}", r['result']).rstrip
        end.join("\n")
        blue("∙ #{name}\n#{formatted_result.indent}")
      when :success
        green("✓ #{name}")
      when :failure
        # sooo hacky
        failure = result.find { |r| r['status'] == 'failure' }
        out = failure.dup
        out.delete('status')
        out.delete('name')
        color(:red,  "✗ #{name} - #{failure['name']}\n#{YAML.without_header(out).indent}")
      when :error
        class_and_message = "#{result['class']} - #{result['message']}"
        backtrace = result['backtrace'].join("\n")
        color(:red, "☠ #{name}\n#{class_and_message.indent}\n#{backtrace.indent}")
      end
    end
    
    def blue(str) color(:blue,str) end
    def green(str) color(:green,str) end
    
    def color(color, str)
      [Term::ANSIColor.send(color), str, Term::ANSIColor.reset].join
    end
    
    # whatahack
    def format_info(str, result)
      YAML.without_header({'FANCY' => result}).sub('FANCY', str)
    end
    
  end
  
  class ExampleEnv
    
    class << self
      
      alias_method :helpers, :class_eval
      attr_accessor :setup_block
      
      def setup(&blk) self.setup_block = blk end
      
      # runs the block in the example environment, returns triple:
      # [status, result, stderr]
      def run(&code)
        env = self.new
        stderr = StringIO.new
        status, result = begin
          real_stderr = $stderr ; $stderr = stderr # swap stderr
          
          env.instance_eval(&self.setup_block) if self.setup_block
          value = env.instance_eval(&code)
          result = env._status == :info ? 
            render_value(value) : render_checks(env._checks)
          [env._status, result]
          
        rescue Object => error
          [:error, render_error(error)]
        ensure
          $stderr = real_stderr # swap stderr back
        end
        [status, result, stderr.rewind && stderr.read]
      end
      
      # -- these "render" methods could probably be factored away
      
      # yaml doesn't want to print a class
      def render_value(value)
        value.kind_of?(Class) ? value.inspect : value
      end
      
      def render_checks(checks)
        failure = nil
        out = []
        checks.each do |check|
          failure = check if check.failure?
          break if failure
          out << OrderedHash do |o|
            o['name'] = check.name
            o['status'] = check.status.to_s
            o['result'] = render_value check.value
          end
        end
        if failure
          out << OrderedHash do |o|
            o['name'] = failure.name
            o['status'] = failure.status.to_s
            o['expected'] = failure.expectation
            o['actual'] = render_value failure.value
          end
        end
        out
      end

      def render_error(error)
        OrderedHash do |o|
          o['class'] = error.class.name
          o['message'] = error.message
          o['backtrace'] = error.backtrace
        end
      end
      
    end
    
    attr_accessor :_checks
    
    def initialize
      @_checks = []
    end
    
    def Check(value)
      file, line_number = caller.first.match(/^(.+):(\d+)/).captures
      line = File.readlines(file)[line_number.to_i - 1].strip
      name = line[/Check\((.+?)\)\s*($|#|\[|\.is.+)/,1]
      check = Check.new(name, value)
      _checks << check
      check
    end
    
    def _status
      (:info    if _checks.empty?) ||
      (:infos   if _checks.all? { |c| c.info? }) ||
      (:success if _checks.all? { |c| c.success? }) ||
      (:failure if _checks.any? { |c| c.failure? })
    end
    
  end
  
  class Examples
    
    def initialize
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
        result = ResultPrinter.new(name, *ExampleEnv.run(&code))
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
  
  class << self
    
    def examples
      @examples ||= Examples.new
    end
    
    def extract_example_file(caller_trace)
      @example_file ||= caller_trace.first.split(":").first
    end
    
    # attr_reader :example_file
    
    def run_directly?
      @example_file == $0
    end
    
  end
  
end

# Defines an example. After definition, an example is an entry in the
# Examples.examples ordered hash, the key is the name, the body is the example
# code
def eg(name = nil, &example)
  Exemplor.extract_example_file caller # only runs once
  return Exemplor::ExampleEnv if name.nil? && example.nil?
  if name.nil?
     file, line_number = caller.first.match(/^(.+):(\d+)/).captures
     line = File.readlines(file)[line_number.to_i - 1].strip
     name = line[/^eg\s*\{\s*(.+?)\s*\}$/,1] if name.nil?
     raise Exemplor::ExampleDefinitionError, "example at #{caller.first} has no name so must be on one line" if name.nil?
  end
  Exemplor.examples.add(name, &example)
end

# Parses the command line args and either runs or lists the examples.
at_exit do
  if Exemplor.run_directly?
    args = ARGV.dup
    if args.delete('--list') || args.delete('-l')
      Exemplor.examples.list(args)
    else
      exit Exemplor.examples.run(args)
    end
  end
end 