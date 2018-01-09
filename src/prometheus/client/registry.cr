module Prometheus
  module Client
    class Registry

      class AlreadyRegisteredError < Exception
      end

      def initialize
        @metrics = {} of Symbol => Symbol
      end

      def register(metric)
        name = metric.name

        raise AlreadyRegisteredError.new("#{name} has already been registered") if exist?(name)

        @metrics[name] = name

        metric
      end

      def exist?(name : Symbol)
        @metrics.has_key?(name)
      end

      def get(name : Symbol)
        @metrics[name]?
      end
    end
  end
end
