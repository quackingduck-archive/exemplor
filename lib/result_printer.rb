module Exemplor
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
          # TODO: successful ones should be green
          format_info("#{{'success' => '✓', 'info' => '•' }[r['status']]} #{r['name']}", r['result']).rstrip
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
end