module TotalEmission
  class Years
    attr_reader :start, :final
    def initialize(start, final)
      @start = start
      @final = final
    end

    def multiple?
      to_a.size > 1
    end

    def to_a
      if start == final
        [start]
      else
        (start..final).to_a
      end
    end
  end
end
