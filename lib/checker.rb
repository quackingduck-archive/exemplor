module Exemplor
  class Check

    attr_reader :expectation, :value, :status

    def initialize(name, value)
      @name  = name
      @value = value
      @status = :info
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
      @status = (value == expectation) ? :success : :failure
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
end