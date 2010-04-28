module Exemplor

  # todo: remove this dependency at some point
  def self.load_ansicolor
    @aniscolor_loaded ||= begin
      $:.unshift Exemplor.path('/../vendor/term-ansicolor-1.0.5/lib')
      require 'term/ansicolor'
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
      Exemplor.load_ansicolor
      case status
      when :info    : blue  format_info(name, result)
      when :success : green icon(status) + ' ' + name
      when :infos   : blue  icon(status) + ' ' + name + "\n" + fancy_result(result).indent
      when :failure : red   icon(status) + ' ' + name + "\n" + fancy_result(result).indent
      when :error
        class_and_message = "#{result['class']} - #{result['message']}"
        backtrace = result['backtrace'].join("\n")
        red icon(status) + ' ' + name + "\n" + class_and_message.indent + "\n" + backtrace.indent
      end
    end

    def fancy_result(checks)
      result.map do |r|
        status, name, result = r['status'].to_sym, r['name'], r['result']
        case status
        when :success : green icon(status) + ' ' + name
        when :failure : red   icon(status) + ' ' + name
        when :info    : blue  format_info(name, result)
        end
      end.join("\n")
    end

    def icon(status)
      case status.to_sym
      # in some font faces, the big dot is little and the little dot is big. sadness
      when :info    : '•'
      when :infos   : '∙'
      when :failure : '✗'
      when :success : '✓'
      when :error   : '☠' # skull and crossbone, aww yeah
      end
    end

    def blue(str)  color(:blue,str)  end
    def green(str) color(:green,str) end
    def red(str)   color(:red,str)   end

    def color(color, str)
      [Term::ANSIColor.send(color), str, Term::ANSIColor.reset].join
    end

    # whatahack
    def format_info(str, result)
      YAML.without_header({'FANCY' => result}).sub('FANCY', icon(:info) + ' ' + str).rstrip
    end

  end
end