module Prometheus
  module Client
    class LabelSetValidator
      RESERVED_LABELS = [:job, :instance]

      class LabelSetError < Exception
      end

      class ReservedLabelError < LabelSetError
      end

      class InvalidLabelSetError < LabelSetError
      end

      def initialize
        @validated = {} of UInt64 => Hash(Symbol, String)
      end

      def valid?(labels : Hash(Symbol, String))
        labels.keys.all? do |key|
          raise ReservedLabelError.new("label #{key} must not start with __") if key.to_s.starts_with?("__")
          raise ReservedLabelError.new("#{key} is reserved") if RESERVED_LABELS.includes?(key)
          true
        end
      end

      def validate(labels : Hash(Symbol, String))
        return labels if @validated[labels.hash]?

        valid?(labels)

        unless @validated.empty? || match?(labels, @validated.first.last)
          raise InvalidLabelSetError.new("labels must have the same signature")
        end

        @validated[labels.hash] = labels
      end

      private def match?(a, b : Hash(Symbol, String))
        a.keys.sort == b.keys.sort
      end
    end
  end
end
