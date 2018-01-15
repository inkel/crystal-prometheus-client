require "./metric"

module Prometheus
  module Client
    class Counter < Metric(Float64)
      def increment(labels = {} of Symbol => String, by : Float64 = 1.0)
        raise ArgumentError.new("increment must be a non-negative number") if by < 0.0
        values[labels] += by
      end
    end
  end
end
