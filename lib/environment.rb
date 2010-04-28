module Exemplor

  class ExampleEnv

    class << self

      alias_method :helpers, :class_eval
      attr_accessor :setup_block

      def setup(&blk) self.setup_block = blk end

      # runs the block in the example environment, returns triple:
      # [status, result, stderr]
      def run(&code)
        env = self.new
        stderr = fake_stderr!
        status, result = begin

          env.instance_eval(&self.setup_block) if self.setup_block
          value = env.instance_eval(&code)
          if env._checks.empty?
            [:info, render_value(value)]
          else # :infos or :success
            [env._status, render_checks(env._checks)]
          end

        rescue Assert::Failure => failure
          [:failure, render_checks(env._checks)]
        rescue Object => error
          [:error, render_error(error)]
        ensure
          restore_stderr!
        end
        [status, result, stderr.rewind && stderr.read]
      end

      # tests are run with a fake stderr so warnings output can be assoicated
      # with the specific test. this is still a little hokey and hard to test
      # properly
      def fake_stderr!
        fake = StringIO.new
        @real_stderr = $stderr
        $stderr = fake
      end

      def restore_stderr!
        $stderr = @real_stderr
      end

      # -- these "render" methods could probably be factored away

      # yaml doesn't want to print a class
      def render_value(value)
        value.kind_of?(Class) ? value.inspect : value
      end

      def render_checks(checks)
        checks.map do |check|
          OrderedHash do |o|
            o['name'] = check.name
            o['status'] = check.status.to_s
            o['result'] = render_value check.value if check.info?
          end
        end
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

    def Show(value)
      name = extract_argstring_from :Show, caller
      check = Show.new(name, value)
      _checks << check
      check
    end

    def Assert(value)
      name = extract_argstring_from :Assert, caller
      check = Assert.new(name, value)
      _checks << check
      check.run
      check
    end

    def Check(value)
      warn "Check is depreciated, use Show"
      name = extract_argstring_from :Check, caller
      check = Show.new(name, value)
      _checks << check
      check
    end

    def extract_argstring_from name, call_stack
      file, line_number = call_stack.first.match(/^(.+):(\d+)/).captures
      line = File.readlines(file)[line_number.to_i - 1].strip
      argstring = line[/#{name}\((.+?)\)\s*($|#|\[|\})/,1]
      raise "unable to extract name for #{name} from #{file} line #{line_number}:\n  #{line}" unless argstring
      argstring
    end

    def _status
      (:success if _checks.all? { |c| c.success? }) ||
       :infos
    end

  end

  def environment
    ExampleEnv
  end
end