module Exemplor
  class Check

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

  class Show < Check

    attr_reader :value

    def status
      :info
    end

  end

  class Assert < Check

    attr_reader :status
    
    # todo remove
    attr_reader :value
    
    # might be better to use throw here
    class Failure < StandardError; end

    def run
      @status = !!@value ? :success : :failure
      raise Failure if failure?
    end

  end

end