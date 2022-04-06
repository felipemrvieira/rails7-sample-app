class CreateEmissionRank < ActiveRecord::Migration[7.0]
  def up
    execute %(
      CREATE MATERIALIZED VIEW emission_ranks AS
        SELECT rank() OVER (
              PARTITION BY  emissions.gas_id,
                            emissions.year,
                            emissions.emission_type_id,
                            territories.territory_type,
                            emissions.sector_id
              ORDER BY (sum(emissions.value)) DESC
            ) AS "position",
          territories.territory_type,
          emissions.emission_type_id,
          emissions.gas_id,
          emissions.year,
          emissions.territory_id,
          emissions.sector_id,
          sum(emissions.value) AS total
        FROM emissions
          JOIN territories ON territories.id = emissions.territory_id
        WHERE territories.territory_type = ANY (ARRAY[0, 1, 2, 4])
        GROUP BY  territories.territory_type,
                  emissions.emission_type_id,
                  emissions.gas_id,
                  emissions.year,
                  emissions.territory_id,
                  emissions.sector_id
      UNION ALL
      SELECT rank() OVER (
              PARTITION BY  emissions.gas_id,
                            emissions.year,
                            territories.territory_type,
                            emissions.emission_type_id
              ORDER BY (sum(emissions.value)) DESC
            ) AS "position",
          territories.territory_type,
          emissions.emission_type_id,
          emissions.gas_id,
          emissions.year,
          emissions.territory_id,
          0 AS sector_id,
          sum(emissions.value) AS total
        FROM emissions
          JOIN territories ON territories.id = emissions.territory_id
        WHERE territories.territory_type = ANY (ARRAY[0, 1, 2, 4])
        GROUP BY  territories.territory_type,
                  emissions.emission_type_id,
                  emissions.gas_id,
                  emissions.year,
                  emissions.territory_id;
    )

    add_index :emission_ranks, :year
    add_index :emission_ranks, :gas_id
    add_index :emission_ranks, :sector_id
    add_index :emission_ranks, :territory_id
    add_index :emission_ranks, :emission_type_id
    add_index :emission_ranks, [:gas_id, :year, :territory_id, :emission_type_id, :sector_id],
      unique: true,
      name: 'index_emission_ranks_on_gas_id_year_territory_id_emission_type'
  end


end


