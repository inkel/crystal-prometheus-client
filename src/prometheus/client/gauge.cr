require "./metric"

module Prometheus
  module Client
    class Gauge < Metric
      def set(labels = {} of Symbol => String, value : Float64 = 0.0)
        values[labels] = value
      end

      def increment(labels = {} of Symbol => String, by : Float64 = 1.0)
        values[labels] += by
      end

      def decrement(labels = {} of Symbol => String, by : Float64 = 1.0)
        values[labels] -= by
      end
    end
  end
end
