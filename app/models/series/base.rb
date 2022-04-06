module Series
  class Base
    attr_reader :emissions, :selected_series, :data_constant
    def initialize(emissions, selected_series, data_constant)
      @emissions = emissions
      @selected_series = selected_series
      @data_constant = data_constant
    end

    def series
      return [] if selected_series.empty?

      selected_series.map do |serie|
        ::Series::Template::Column.new(
          serie.name,
          data_constant.for(emissions, Struct.new(:serie).new(serie.id))
        )
      end
    end
  end
end
