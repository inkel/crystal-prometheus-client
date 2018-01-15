require "./metric"

module Prometheus
  module Client
    class Histogram < Metric(Value)
      DEFAULT_BUCKETS = [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0]

      getter buckets

      def initialize(@name : Symbol, @docstring : String, @base_labels = {} of Symbol => String, @buckets = DEFAULT_BUCKETS)
        Value.validate_buckets(buckets)
        super(name, docstring, base_labels)
      end

      def observe(labels : Hash(Symbol, String), value : Float64)
        values[labels].observe(value)
      end

      def values
        @bucket_values ||= Hash(Hash(Symbol, String), Value).new { |h, k| h[k] = Value.new(buckets) }
      end

      class Value < Hash(Float64, Float64)
        getter sum, total

        def initialize(buckets : Array(Float64))
          super()
          @sum = 0.0
          @total = 0

          buckets.each do |bucket|
            self[bucket] = 0.0
          end
        end

        def observe(value : Float64)
          @sum += value
          @total += 1
          each_key do |bucket|
            self[bucket] += 1 if value <= bucket
          end
          self
        end

        def self.validate_buckets(buckets : Array(Float64))
          raise ArgumentError.new("buckets cannot be empty") if buckets.empty?
          raise ArgumentError.new("unsorted buckets") unless buckets == buckets.sort
          raise ArgumentError.new("duplicated buckets") unless buckets.size == buckets.uniq.size
        end
      end
    end
  end
end
