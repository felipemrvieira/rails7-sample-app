module Emissions
  class Base
    attr_reader :parameters, :constant

    def initialize(parameters, constant)
      @parameters = parameters
      @constant = constant
    end

    def series
      constant::Series.new(emissions, selected_series).series
    end

    private

    def emissions
      Emission
        .select(fields_to_query)
        .where(conditions)
        .group(:serie, :data)
    end

    def fields_to_query
      fail NotImplementedError, 'Sorry, you have to override fields_to_query'
    end

    def selected_series
      fail NotImplementedError, 'Sorry, you have to override selected_series'
    end

    def conditions
      fail NotImplementedError, 'Sorry, you have to override conditions'
    end

    def years
      raise "Array of year parameters was expected" if parameters[:year].blank?

      first_year = parameters[:year].first
      last_year = parameters[:year].last

      TotalEmission::Years.new(first_year, last_year)
    end
  end
end
