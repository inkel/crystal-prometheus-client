module Prometheus
  module Client
    class Metric
      getter name, docstring, base_labels

      def initialize(@name : Symbol, @docstring : String, @base_labels = {} of Symbol => String)
        validate_name
        validate_docstring
      end

      RE_NAME = /\A[a-zA-Z_:][a-zA-Z0-9_:]*\Z/

      private def validate_name
        raise ArgumentError.new("metric name must match #{RE_NAME}") unless name.to_s =~ RE_NAME
      end

      private def validate_docstring
        raise ArgumentError.new("docstring must be given") if docstring.empty?
      end
    end
  end
end
