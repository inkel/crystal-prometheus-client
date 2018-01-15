require "../../spec_helper"
require "../../../src/prometheus/client/registry"

def with_registry
  yield Prometheus::Client::Registry.new
end

struct Metric
  property name

  def initialize(@name : Symbol)
  end
end

describe Prometheus::Client::Registry do
  describe ".new" do
    it "returns a new registry instance" do
      with_registry do |registry|
        registry.should be_a(Prometheus::Client::Registry)
      end
    end
  end

  describe "#register" do
    it "registers a new metric container and returns it" do
      metric = Metric.new(:test)

      with_registry do |registry|
        registry.register(metric).should eq(metric)
      end
    end

    it "raises an exception if a metric name gets registered twice" do
      metric = Metric.new(:test)

      with_registry do |registry|
        registry.register(metric)

        expect_raises(Prometheus::Client::Registry::AlreadyRegisteredError) do
          registry.register(metric)
        end
      end
    end
  end

  describe "#exist?" do
    it "returns true if a metric name has been registered" do
      with_registry do |registry|
        registry.register(Metric.new(name: :test))

        registry.exist?(:test).should eq(true)
      end
    end

    it "returns false if a metric name has not been registered yet" do
      with_registry do |registry|
        registry.exist?(:test).should eq(false)
      end
    end
  end

  describe "#get" do
    it "returns a previously registered metric container" do
      with_registry do |registry|
        registry.register(Metric.new(name: :test))

        registry.get(:test).should eq(:test)
      end
    end

    it "returns nil if the metric has not been registered yet" do
      with_registry do |registry|
        registry.get(:test).should eq(nil)
      end
    end
  end
end
