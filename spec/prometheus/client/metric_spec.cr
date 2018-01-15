require "../../spec_helper"
require "../../../src/prometheus/client/metric"

def with_metric
  yield Prometheus::Client::Metric(Float64).new(:test, "some docstring", {:label => "value"})
end

describe Prometheus::Client::Metric do
  describe ".new" do
    it "returns a new registry instance" do
      with_metric do |metric|
        metric.should be_a(Prometheus::Client::Metric(Float64))
      end
    end

    it "validates name" do
      [:"0123", :"foo bar", :"foo-bar"].each do |name|
        expect_raises(ArgumentError) do
          Prometheus::Client::Metric(Float64).new(name, "some doc")
        end
      end
    end

    it "validates docstring" do
      expect_raises(ArgumentError) do
        Prometheus::Client::Metric(Float64).new(:test, "")
      end
    end
  end
end
