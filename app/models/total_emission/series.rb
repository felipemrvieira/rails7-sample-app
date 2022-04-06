require_dependency '../series/base.rb'

module TotalEmission
  class Series < ::Series::Base
    def initialize(emissions, selected_series)
      super(emissions, selected_series, ::TotalEmission::Data)
    end
  end
end
