require "http/server"
require "../../client"

module Prometheus
  module HTTP
    module Handlers
      class Collector
        include ::HTTP::Handler

        property registry

        @requests : Prometheus::Client::Counter
        @exceptions : Prometheus::Client::Counter
        @durations : Prometheus::Client::Histogram

        def initialize(@registry : Prometheus::Client::Registry = Prometheus::Client.registry)
          base_labels = {} of Symbol => String

          @requests = registry.counter(
            :http_requests_total,
            "The total number of HTTP requests handled by the application.",
            base_labels
          )

          @exceptions = registry.counter(
            :http_exceptions_total,
            "The total number of exceptions raised by the application.",
            base_labels
          )

          @durations = registry.histogram(
            :http_request_duration_total_milliseconds,
            "The HTTP response duration of the application.",
            base_labels,
            Prometheus::Client::Histogram::DEFAULT_BUCKETS
          )
        end

        def call(ctx : ::HTTP::Server::Context)
          trace(ctx) { call_next(ctx) }
        end

        private def trace(ctx : ::HTTP::Server::Context)
          start = Time.now
          yield.tap do
            @requests.increment(
              {
                :code   => ctx.response.status_code.to_s,
                :method => ctx.request.method.upcase,
                :path   => ctx.request.path,
              }
            )
          end
        end
      end
    end
  end
end
