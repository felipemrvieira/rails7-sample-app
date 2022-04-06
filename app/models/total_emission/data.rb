module TotalEmission
  class Data < ::DefaultData
    @@cached = Hash[Sector.pluck(:name, :id)].freeze

    def initialize(emissions, serie)
      super(serie, emissions)
    end

    def name(data_emission)
      data = data_emission.data.to_i
      sector_name = @@cached[data]

      return sector_name unless sector_name.blank?

      data
    end
  end
end
