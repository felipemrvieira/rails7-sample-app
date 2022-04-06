module Series
  module Template
    Base = Struct.new(:name, :type, :data, :showInTable) do
      def initialize(name, type, data, show_in_table = true)
        super(name, type, data, show_in_table)
      end
    end

    Spline = Struct.new(:name, :type, :yAxis, :data, :showInTable) do
      def initialize(name, data, show_in_table = true)
        super(name, 'spline', 1, data, show_in_table)
      end
    end

    class Column < Base
      def initialize(name, data)
        super(name, 'column', data)
      end
    end

    Pie = Struct.new(:name, :type, :center, :size, :showInLegend, :data) do
      def initialize(name, data)
        super(name, 'pie', [100, 80], 100, false, data)
      end
    end
  end
end
