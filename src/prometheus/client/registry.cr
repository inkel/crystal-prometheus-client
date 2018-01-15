require "./counter"
require "./gauge"
require "./histogram"

module Prometheus
  module Client
    class Registry
      class AlreadyRegisteredError < Exception
      end

      def initialize
        @metrics = Hash(Symbol, Metric).new
      end

      def register(metric)
        name = metric.name

        raise AlreadyRegisteredError.new("#{name} has already been registered") if exist?(name)

        @metrics[name] = metric

        metric
      end

      def exist?(name : Symbol)
        @metrics.has_key?(name)
      end

      def get(name : Symbol)
        raise ArgumentError.new("#{name} hasn't been registered") unless exist?(name)
        @metrics[name]
      end

      def counter(name, docstring, base_labels)
        register(Prometheus::Client::Counter.new(name, docstring, base_labels))
      end

      def gauge(name, docstring, base_labels)
        register(Prometheus::Client::Gauge.new(name, docstring, base_labels))
      end

      def histogram(name, docstring, base_labels, buckets)
        register(Prometheus::Client::Histogram.new(name, docstring, base_labels, buckets))
      end

      def counter(name, docstring, base_labels)
        register(Prometheus::Client::Counter.new(name, docstring, base_labels))
      end

      def gauge(name, docstring, base_labels)
        register(Prometheus::Client::Gauge.new(name, docstring, base_labels))
      end

      def histogram(name, docstring, base_labels, buckets)
        register(Prometheus::Client::Histogram.new(name, docstring, base_labels, buckets))
      end
    end
  end
end
