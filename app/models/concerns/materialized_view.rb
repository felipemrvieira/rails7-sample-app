module MaterializedView
  extend ActiveSupport::Concern

  def readonly?
    true
  end

  class_methods do
    def refresh(concurrent: true, **)
      connection.execute %(
        REFRESH MATERIALIZED VIEW #{concurrent ? 'CONCURRENTLY' : ''} #{table_name}
      )
    end
  end
end
