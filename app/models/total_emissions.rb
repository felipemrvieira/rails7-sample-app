class TotalEmissions < Emissions::Base
  def initialize(parameters)
    super(parameters, TotalEmission)
  end

  def series
    series = get_series
    return series if parameters['social_economic'].blank?

    # Used in sankey details totals chart
    social_economic_name = parameters['social_economic']
    territory = Territory.find(territories.first)
    series << SectorEmission::SocialEconomic::Series.for(territory, years.to_a, social_economic_name)
  end

  private

  def fields_to_query
    if years.multiple?
      'sector_id AS serie, year AS data, SUM(value) AS total'
    else
      'territory_id AS serie, sector_id AS data, SUM(value) AS total'
    end
  end

  def conditions
    EmissionTypeCached.set_conditions(emission_type_name, initial_conditions)
  end

  def initial_conditions
    {
      year: years.to_a,
      gas_id: parameters[:gas],
      territory: territories
    }
  end

  def emission_type_name
    parameters[:emission_type]
  end

  def selected_series
    if years.multiple?
      @all_sectors ||= Sector.all
    else
      Territory.find(parameters[:territories])
    end
  end

  def territories
    parameters[:territories]
  end

  @@cached = Hash[Sector.pluck(:id, :name)].freeze

  def get_series
    first_year = parameters[:year].first
    last_year = parameters[:year].last

    # net emmissions sends array(with values 1 and 5) instead integer
    if parameters[:emission_type_id].kind_of?(Array) &&
      parameters[:emission_type_id].include?(1) && 
      parameters[:emission_type_id].include?(5)

      emission_ranks = EmissionRank.net_total_in_the_year_range(
        start_year: first_year,
        end_year: last_year,
        gas_id: parameters[:gas],
        territory_id: parameters[:territories],
        emission_type_id: parameters[:emission_type_id]
      )
    else
      emission_ranks = EmissionRank.total_by_sector_in_year_range(
        start_year: first_year,
        end_year: last_year,
        gas_id: parameters[:gas],
        territory_id: parameters[:territories],
        emission_type_id: parameters[:emission_type_id]
      )
    end

    emission_ranks_by_sector = emission_ranks.group_by { |e| e.sector_id }
    emission_ranks_by_sector.map do |sector_id, emission_ranks|
      ::Series::Template::Column.new(
        @@cached[sector_id],
        emission_ranks.map do |emission_rank|
          year = emission_rank.year
          total = emission_rank.total&.to_f&.round(2)

          ::Data::Template::Base.new(year, total)
        end
      )
    end
  end
end
