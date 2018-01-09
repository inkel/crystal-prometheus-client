require "../spec_helper"
require "../../src/prometheus/client"

describe Prometheus::Client do
  describe ".registry" do
    it "returns a registry object" do
      Prometheus::Client.registry.should be_a(Prometheus::Client::Registry)
    end

    it "memorizes the returned object" do
      Prometheus::Client.registry.should eq(Prometheus::Client.registry)
    end
  end
end
