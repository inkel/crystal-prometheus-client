require "./client/registry"

module Prometheus
  module Client
    def self.registry
      @@registry ||= Registry.new
    end
  end
end
