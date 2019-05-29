require "../../spec_helper"
require "../../../src/prometheus/client/registry"

def with_registry
  yield Prometheus::Client::Registry.new
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
      metric = Prometheus::Client::Metric.new(:test, "foo")

      with_registry do |registry|
        registry.register(metric).should eq(metric)
      end
    end

    it "raises an exception if a metric name gets registered twice" do
      metric = Prometheus::Client::Metric.new(:test, "foo")

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
        registry.register(metric = Prometheus::Client::Metric.new(:test, "foo"))

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
        counter = Prometheus::Client::Counter.new(:foo, "lorem ipsum", {:bar => "baz"})

        registry.register(counter)

        registry.get(:foo).should eq(counter)
      end
    end

    it "fails if the metric has not been registered yet" do
      with_registry do |registry|
        expect_raises(ArgumentError) do
          registry.get(:test)
        end
      end
    end
  end

  describe "#counter" do
    it "should return a Prometheus::Client::Counter" do
      with_registry do |registry|
        counter = registry.counter(:foo, "lorem ipsum", {:bar => "baz"})
        counter.should be_a(Prometheus::Client::Counter)
        counter.name.should eq(:foo)
        counter.docstring.should eq("lorem ipsum")
        counter.base_labels.should eq({:bar => "baz"})
      end
    end
  end

  describe "#gauge" do
    it "should return a Prometheus::Client::Gauge" do
      with_registry do |registry|
        gauge = registry.gauge(:foo, "lorem ipsum", {:bar => "baz"})
        gauge.should be_a(Prometheus::Client::Gauge)
        gauge.name.should eq(:foo)
        gauge.docstring.should eq("lorem ipsum")
        gauge.base_labels.should eq({:bar => "baz"})
      end
    end
  end

  describe "#histogram" do
    it "should return a Prometheus::Client::Histogram" do
      with_registry do |registry|
        histogram = registry.histogram(:foo, "lorem ipsum", {:bar => "baz"}, [0.5, 1.0, 2.0])
        histogram.should be_a(Prometheus::Client::Histogram)
        histogram.name.should eq(:foo)
        histogram.docstring.should eq("lorem ipsum")
        histogram.base_labels.should eq({:bar => "baz"})
        histogram.buckets.should eq([0.5, 1.0, 2.0])
      end
    end
  end

  describe "#counter" do
    it "should return a Prometheus::Client::Counter" do
      with_registry do |registry|
        counter = registry.counter(:foo, "lorem ipsum", {:bar => "baz"})
        counter.should be_a(Prometheus::Client::Counter)
        counter.name.should eq(:foo)
        counter.docstring.should eq("lorem ipsum")
        counter.base_labels.should eq({:bar => "baz"})
      end
    end
  end

  describe "#gauge" do
    it "should return a Prometheus::Client::Gauge" do
      with_registry do |registry|
        gauge = registry.gauge(:foo, "lorem ipsum", {:bar => "baz"})
        gauge.should be_a(Prometheus::Client::Gauge)
        gauge.name.should eq(:foo)
        gauge.docstring.should eq("lorem ipsum")
        gauge.base_labels.should eq({:bar => "baz"})
      end
    end
  end

  describe "#histogram" do
    it "should return a Prometheus::Client::Histogram" do
      with_registry do |registry|
        histogram = registry.histogram(:foo, "lorem ipsum", {:bar => "baz"}, [0.5, 1.0, 2.0])
        histogram.should be_a(Prometheus::Client::Histogram)
        histogram.name.should eq(:foo)
        histogram.docstring.should eq("lorem ipsum")
        histogram.base_labels.should eq({:bar => "baz"})
        histogram.buckets.should eq([0.5, 1.0, 2.0])
      end
    end
  end
end
