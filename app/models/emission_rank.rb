class EmissionRank < ApplicationRecord
  include MaterializedView

  belongs_to :gas
  belongs_to :territory
  belongs_to :emission_type

  self.table_name = :emission_ranks

  def self.net_total_in_the_year_range( gas_id:,
    end_year:,
    start_year:,
    territory_id:,
    emission_type_id: )

    # sql = "SELECT SUM(total) as total, year, sector_id
    #   from(
    #     (
    #       -- Emissoes totais somadas
    #       SELECT gs.year AS year, SUM(COALESCE(er.total, 0.0)) AS total, 9 AS sector_id
    #       FROM generate_series(?, ?) AS gs(year) CROSS JOIN sectors s
    #       LEFT JOIN emission_ranks er ON
    #       gs.year = er.year
    #       AND er.gas_id IN (?)
    #       AND territory_id IN (?)
    #       AND emission_type_id IN (1)
    #       AND s.id = er.sector_id 
    #       GROUP BY gs.year
    #       ORDER BY gs.year
    #     )
    #     UNION ALL
    #     (
    #       -- remoções nao vazias
    #       SELECT gs.year AS year, SUM(COALESCE(er.total, 0.0))*-1  AS total, 9 AS sector_id FROM generate_series(?, ?) AS gs(year) CROSS JOIN sectors s
    #       LEFT JOIN emission_ranks er ON
    #       gs.year = er.year
    #       AND er.gas_id IN (?)
    #       AND territory_id IN (?)
    #       AND emission_type_id IN (5)
    #       AND s.id = er.sector_id
    #       WHERE total <> 0
    #       GROUP BY gs.year, s.id 
    #       ORDER BY gs.year
    #     ) 
    #   )x
    #   GROUP BY year, sector_id;"

      sql = "SELECT e.year, e.sector_id, coalesce(e.total, 0) - coalesce(r.total, 0) as total
      FROM
      (
        SELECT gs.year, er.total, s.id AS sector_id 
        FROM generate_series(?, ?) AS gs(year) 
        CROSS JOIN sectors s
        LEFT JOIN emission_ranks er ON gs.year = er.year
        AND er.gas_id IN (?)
        AND territory_id IN (?)
        AND emission_type_id IN (1)
        AND s.id = er.sector_id 
        ORDER BY gs.year
      ) e
      LEFT JOIN
      (
        SELECT gs.year AS year, SUM(COALESCE(Abs(er.total), 0.0))  AS total, s.id as sector_id 
        FROM generate_series(?, ?) AS gs(year) CROSS JOIN sectors s
        LEFT JOIN emission_ranks er ON gs.year = er.year
        AND er.gas_id IN (?)
        AND territory_id IN (?)
        AND emission_type_id IN (5)
        AND s.id = er.sector_id
        WHERE total <> 0
        GROUP BY gs.year, s.id
        ORDER BY gs.year
      ) r
      on e.sector_id = r.sector_id AND e.year = r.year
      ORDER BY e.year, total"

    EmissionRank.find_by_sql([
        sql, 
        start_year.to_i, end_year.to_i, gas_id, territory_id,
        start_year.to_i, end_year.to_i, gas_id, territory_id
      ])

  end


  def self.total_by_sector_in_year_range( gas_id:,
                                          end_year:,
                                          start_year:,
                                          territory_id:,
                                          emission_type_id: )
    select('gs.year', 'SUM(COALESCE(er.total, 0.0)) AS total', 's.id AS sector_id').
    from( pg_year_range_series(start_year, end_year) ).
    joins( cross_with_sectors_and_left_joins(gas_id, territory_id, emission_type_id) ).
    group('gs.year', 's.id').
    order('gs.year', 'total').
    to_a
  end

  private

  # Maybe these methods would be better fit into ApplicationRecord or a module
  def self.pg_year_range_series(from, to)
    sanitize_sql([
      'generate_series(?, ?) AS gs(year)',
      from.to_i,
      to.to_i
    ])
  end

  def self.cross_with_sectors_and_left_joins(gas_id, territory_id, emission_type_id)
    sanitize_sql([ %{
      CROSS JOIN sectors s
      LEFT JOIN emission_ranks er ON
            gs.year = er.year
        AND er.gas_id IN (?)
        AND territory_id IN (?)
        AND emission_type_id IN (?)
        AND s.id = er.sector_id
      },
      gas_id,
      territory_id,
      emission_type_id
    ])
  end
end
